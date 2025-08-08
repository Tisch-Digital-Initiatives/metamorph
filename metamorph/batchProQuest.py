import os
from datetime import datetime

from .interface import Interface
from .archive import ArchiveDirectory
from .batch import Batch
from . import config


class BatchProQuest(Batch):
    def batchit(self):
        self.package()
        coll = self.outarchive.glob('**/*.xml')
        xslt = os.path.join(config.xsltdir, 'Proquest.xslt')
        now = datetime.now()
        outfile = now.strftime('%Y-%m-%d-%H%M%S') + '_ProQuest_Ingest.xml'
        self.xsl_transform(coll, outfile, xslt)
        ingest = self.outarchive.read_member(outfile)
        subjects = self.extract_subjects(ingest)
        self.qa_it(outfile)


if __name__ == '__main__':
    adir = os.path.join(config.testdir, 'ProQuest_test_data')
    a = ArchiveDirectory(adir)
    b = BatchProQuest(a)
    b.batchit()
    config.ui.message(b.outarchive.read_member('Ingest_Me.xml'))    
    b.outarchive.delete()