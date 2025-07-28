import os

from .batch import Batch
from .archive import ArchiveDirectory
from . import config


class BatchACM(Batch):
    def batchit(self):
        self.package()
        xslt = os.path.join(config.xsltdir, 'ACM.xslt')
        self.xsl_transform(r"xml\mets.xml", 'Ingest_Me.xml', xslt)
        ingest = self.outarchive.read_member('Ingest_Me.xml')
        subjects = self.extract_subjects(ingest)
        self.qa_it('Ingest_Me.xml')


if __name__ == '__main__':
    adir = os.path.join(config.testdir, 'ACM_test_data')
    a = ArchiveDirectory(adir)
    b = BatchACM(a)
    b.batchit()
    config.ui.message(b.outarchive.read_member('Ingest_Me.xml'))    
    b.outarchive.delete()