import os

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
        xslt = os.path.join(config.xsltdir, 'Springer.xslt')
        self.xsl_transform(coll, 'Ingest_Me.xml', xslt)
        ingest = self.outarchive.read_member('Ingest_Me.xml')
        subjects = self.extract_subjects(ingest)
        self.qa_it('Ingest_Me.xml')


if __name__ == '__main__':
    adir = os.path.join(config.testdir, 'Springer_test_data')
    a = ArchiveDirectory(adir)
    b = BatchSpringer(a)   
    b.batchit()
    config.ui.message(b.outarchive.read_member('Ingest_Me.xml'))
    b.outarchive.delete()