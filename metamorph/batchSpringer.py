import os
from datetime import datetime

from .interface import Interface
from .archive import ArchiveDirectory
from .batch import Batch
from . import config


class BatchSpringer(Batch):
    def batchit(self):
        self.package()
        coll = self.inarchive.glob('**/*.xml.Meta')
        self.outarchive.mkbranch('xml')
        for f in coll:
            fname = os.path.basename(f)
            newname = os.path.join('xml', os.path.splitext(fname)[0])
            self.inarchive.copy_member(f, self.outarchive, newname)
        
        coll = self.outarchive.glob('**/*.xml')
        paths = []
        for f in coll:
            path = os.path.join(self.outarchive.getroot(), f)
            path = path.replace('\\', '/')
            paths.append(path)
        content = self.collection(paths)
        xslt = os.path.join(config.xsltdir, 'Springer.xslt')
        output = self.xsl_transform(content, xslt)
        
        now = datetime.now()
        outfile = now.strftime('%Y-%m-%d-%H%M%S') + '_Springer_Ingest.xml'
        self.outarchive.write_member(outfile, output)
        content = self.outarchive.read_member(outfile, encoding='utf-8')
        self.extract_subjects(content)
        self.qa_it(outfile)


if __name__ == '__main__':
    adir = os.path.join(config.testdir, 'Springer_test_data')
    a = ArchiveDirectory(adir)
    b = BatchSpringer(a)   
    b.batchit()
    config.ui.message(b.outarchive.read_member('Ingest_Me.xml'))
    b.outarchive.delete()