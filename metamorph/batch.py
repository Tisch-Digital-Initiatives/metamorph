# = batch.rb
#
# == class Batch
#
# The Batch class represents an abstract transformation procedure.
#
# The Batch takes an input directory structure containing metadata
# and content described by the metadata, transforms the metadata, and
# creates an output directory structure suitable for import into
# a repository.
#
# Subclasses of Batch implement the transformations of particular
# archive sources.
import os
from os import path
from datetime import datetime, timezone

from .archive import Archive, ArchiveDirectory
from .xmldoc import Xmldoc
from . import config

ui = config.ui


class Batch:
    inarchive = None
    outarchive = None
    username = ''
    
    def __init__(self, inarchive=None, outarchive=None, username='Anonymous'):
        self.username = username
        if isinstance(inarchive, Archive):
            self.inarchive = inarchive
        else:
            adir = ui.question(
                'What is the directory you are working with?')
            while not os.path.exists(adir):
                adir = ui.question(
                    'That directory does not exist \
                    \n\nWhat is the directory you are working with?')
                adir = adir.strip()
            self.inarchive = ArchiveDirectory(adir)
        if not outarchive:
            odir = ui.question(
                'Specify an output directory name (blank for default)')
            curdir = os.getcwd()
            os.chdir(os.path.dirname(adir))
            while odir and os.path.exists(odir):
                odir = ui.question(
                    'That directory already exists \
                    \n\nSpecify an output directory name (blank for default)')
                odir = odir.strip()
            if odir:
                self.outarchive = ArchiveDirectory(odir, 'w')
            else:
                odirroot = '_'.join([self.inarchive.getroot(), 'processed'])
                odir = odirroot
                n = 0
                while os.path.exists(odir):
                    n = n + 1
                    odir = '_'.join([odirroot, str(n)])
                self.outarchive = ArchiveDirectory(odir, 'w')
            os.chdir(curdir)
    
    # Defines context manager, allows Batch to be used in 'with' statements
    def __enter__(self):
        return self
    
    # Defines context manager, allows Batch to be used in 'with' statements
    def __exit__(self, type, value, traceback):
        pass
    
    def package(self):
        files = self.inarchive.glob('**/*.xml')
        if files:
            ui.log("copying XML files")
            self.outarchive.mkbranch('xml')
        for f in files:
            out = os.path.join('xml', os.path.basename(f))
            self.inarchive.copy_member(f, self.outarchive, out)
        
        files = self.inarchive.glob('**/*.xlsx')
        if files:
            ui.log("copying Excel files")
            self.outarchive.mkbranch('excel')
        for f in files:
            out = os.path.join('excel', os.path.basename(f))
            self.inarchive.copy_member(f, self.outarchive, out)
        
        files = self.inarchive.glob('**/*.pdf')
        if files:
            ui.log("copying PDF files")
            self.outarchive.mkbranch('pdf')
        for f in files:
            out = os.path.join('pdf', os.path.basename(f))
            self.inarchive.copy_member(f, self.outarchive, out)
        
        files = self.inarchive.glob('**/*.tif')
        if files:
            ui.log("copying TIFF files")
            self.outarchive.mkbranch('tif')
        for f in files:
            out = os.path.join('tif', os.path.basename(f))
            self.inarchive.copy_member(f, self.outarchive, out)
        
        files = self.inarchive.glob('**/*.mrc')
        if files:
            ui.log("copying MARC files")
            self.outarchive.mkbranch('mrc')
        for f in files:
            out = os.path.join('mrc', os.path.basename(f))
            self.inarchive.copy_member(f, self.outarchive, out)
        
        files = self.inarchive.glob('**/*.zip')
        if files:
            ui.log("copying ZIP files")
            self.outarchive.mkbranch('zip')
        for f in files:
            out = os.path.join('zip', os.path.basename(f))
            self.inarchive.copy_member(f, self.outarchive, out)
    
    def __collection(self, xmlfiles):
        collection = '<?xml version=\'1.0\' encoding = \'UTF-8\'?>\n'
        collection += '<collection>\n'
        for f in xmlfiles:
            collection += '    <doc href=\'' + f + '\'/>\n'
        collection += '</collection>\n'
        return collection
    
    def qa_it(self, xml_file):
        answer = ui.yesno(
            "\nWould you like to open the transformed xml?", 'y')
        if answer:
            self.outarchive.launch('subjects.txt')
            self.outarchive.launch(xml_file)
            
    def xsl_transform(self, inpath, outpath, xslt):
        ui.log("doing transform")
        if isinstance(inpath, str):
            content = self.outarchive.read_member(inpath)
        else:
            paths = []
            for f in inpath:
                path = os.path.join(self.outarchive.getroot(), f)
                path = path.replace('\\', '/')
                paths.append(path)
            content = self.__collection(paths)
        xdoc = Xmldoc(content)
        output = xdoc.apply_xslt(xslt)
        name = self.username
        dt = datetime.now(timezone.utc).astimezone().isoformat()
        qr_note = "<tufts:qr_note>Metadata reviewed by: " + name + " on " + dt + "</tufts:qr_note>"
        xdoc2 = Xmldoc(output)
        output = xdoc2.replace_element('tufts:qr_note', qr_note)
        output = output.encode(encoding='utf-8')
        self.outarchive.write_member(outpath, output)
    
    def extract_subjects(self, file):
        xdoc = Xmldoc(file)
        mira_ns = {
                   "dc11": "http://purl.org/dc/elements/1.1/",
                   "bf2": "http://bibframe.org/vocab/",
                   "bibframe": "http://bibframe.org/vocab/",
                   "dc": "http://purl.org/dc/terms/",
                   "dc11": "http://purl.org/dc/elements/1.1/",
                   "ebucore": "http://www.ebu.ch/metadata/ontologies/ebucore/ebucore#",
                   "edm": "http://www.europeana.eu/schemas/edm/",
                   "foaf": "http://xmlns.com/foaf/0.1/",
                   "mads": "http://www.loc.gov/mads/rdf/v1#",
                   "marcrelators": "http://id.loc.gov/vocabulary/relators/",
                   "model": "info:fedora/fedora-system:def/model#",
                   "premis": "http://www.loc.gov/premis/rdf/v1#",
                   "rdfs": "http://www.w3.org/2000/01/rdf-schema#",
                   "scholarsphere": "http://scholarsphere.psu.edu/ns#",
                   "terms": "http://dl.tufts.edu/terms#",
                   "tufts": "http://dl.tufts.edu/terms#",
                   "xsi": "http://www.w3.org/2001/XMLSchema-instance"
                   }
        xpaths = {
                  "creators": "//dc11:creator",
                  "contributors": "//dc11:contributor",
                  "persnames": "//mads:PersonalName",
                  "corpnames": "//mads:CorporateName",
                  "depts": "//tufts:creator_department",
                  "spatial": "//dc:spatial",
                  "subjects": "//dc11:subject",
                  "genres": "//mads:GenreForm"
                  }
        xdoc.set_namespaces(mira_ns)
        fields = {}
        for k in xpaths.keys():
            l = xdoc.xpath_to_stringlist(xpaths[k])
            l = list(set(l))
            l.sort()
            fields[k] = "\n".join(l)
        xpath = "//dc11:date"
        dates = xdoc.xpath_to_stringlist(xpath)
        fields["dates"] = "\n".join(dates)
        
        output = "Terms recently used\n\n"
        output += "Names:\n            Creators\n"
        output += fields["creators"]
        output += "\n\n            Contributors\n"
        output += fields["contributors"]
        output += "\n\nDates:\n"
        output += fields["dates"]
        output += "\n\nSubjects:\n            Corporate Terms\n"
        output += fields["corpnames"]
        output += "\n\n            Department Names\n"
        output += fields["depts"]
        output += "\n\n            Geographic Terms\n"
        output += fields["spatial"]
        output += "\n\n            Personal names as subject\n"
        output += fields["persnames"]
        output += "\n\n            LCSH\n"
        output += fields["subjects"]
        output += "\n\n            Genre Terms\n"
        output += fields["genres"]
        self.outarchive.write_member(r"subjects.txt", output)
    
    def batchit(self):
        ui.message('Batch subclass needs a batchit method')


if __name__ == '__main__':
    adir = os.path.join(config.testdir, 'ProQuest_test_data')
    a = ArchiveDirectory(adir)
    b = Batch(a)
    b.package()
    coll = b.outarchive.glob('**/*.xml')
    xslt = os.path.join(config.xsltdir, 'ProQuest.xslt')
    b.xsl_transform(coll, 'Ingest_Me.xml', xslt)
    ingest = b.outarchive.read_member('Ingest_Me.xml')
    subjects = b.extract_subjects(ingest)
    b.qa_it('Ingest_Me.xml')
    b.outarchive.delete()