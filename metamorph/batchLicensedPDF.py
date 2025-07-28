import os

from .interface import Interface
from .archive import ArchiveDirectory
from .batch import Batch
from . import config


class BatchLicensedPDF(Batch):
    def batchit(self):
        self.package()
        files = self.outarchive.glob('xml/*.xml')
        if len(files) > 1:
            config.ui.message('\nDirectory contains more than 1 XML file')
            input_xml = config.ui.multiple_choice(
                'Which is the XML file containing the metadata for ingest?',
                files)
        else:
            input_xml = files[0]
        config.ui.message('input file = ' + input_xml)
        
        xslt = os.path.join(config.xsltdir, 'licensed_pdf.xslt')
        self.xsl_transform(input_xml, 'Ingest_Me.xml', xslt)
        ingest = self.outarchive.read_member('Ingest_Me.xml')
        subjects = self.extract_subjects(ingest)
        self.qa_it('Ingest_Me.xml')


if __name__ == '__main__':
    adir = os.path.join(config.testdir, 'Licensed_PDF_test_data')
    a = ArchiveDirectory(adir)
    b = BatchLicensedPDF(a)
    b.batchit()
    config.ui.message(b.outarchive.read_member('Ingest_Me.xml'))    
    b.outarchive.delete()