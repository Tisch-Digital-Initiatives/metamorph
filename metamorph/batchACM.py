import os
from datetime import datetime

from .batch import Batch
from .archive import ArchiveDirectory
from . import config


class BatchACM(Batch):
    def batchit(self):
        self.package()
        xslt = os.path.join(config.xsltdir, 'ACM.xslt')
        now = datetime.now()
        outfile = now.strftime('%Y-%m-%d-%H%M%S') + '_Springer_Ingest.xml'
        self.xsl_transform(r"xml\mets.xml", outfile, xslt)
        ingest = self.outarchive.read_member(outfile)
        self.extract_subjects(ingest)
        self.qa_it(outfile)


if __name__ == '__main__':
    adir = os.path.join(config.testdir, 'ACM_test_data')
    a = ArchiveDirectory(adir)
    b = BatchACM(a)
    b.batchit()
    config.ui.message(b.outarchive.read_member('Ingest_Me.xml'))    
    b.outarchive.delete()