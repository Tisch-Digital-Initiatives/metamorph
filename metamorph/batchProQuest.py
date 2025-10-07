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
        paths = []
        for f in coll:
            path = os.path.join(self.outarchive.getroot(), f)
            path = path.replace('\\', '/')
            paths.append(path)
        content = self.collection(paths)
        xslt = os.path.join(config.xsltdir, 'Proquest.xslt')
        output = self.xsl_transform(content, xslt)
        
        now = datetime.now()
        outfile = now.strftime('%Y-%m-%d-%H%M%S') + '_ProQuest_Ingest.xml'
        self.outarchive.write_member(outfile, output)
        content = self.outarchive.read_member(outfile)
        self.extract_subjects(content)
        self.qa_it(outfile)


if __name__ == '__main__':
    adir = os.path.join(config.testdir, 'ProQuest_test_data')
    a = ArchiveDirectory(adir)
    b = BatchProQuest(a)
    b.batchit()
    config.ui.message(b.outarchive.read_member('Ingest_Me.xml'))    
    b.outarchive.delete()