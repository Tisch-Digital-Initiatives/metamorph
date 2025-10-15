import os
from datetime import datetime

from .batch import Batch
from .archive import ArchiveDirectory
from . import config


class BatchACM(Batch):
    def batchit(self):
        self.package()
        content = self.outarchive.read_member(r"xml\mets.xml")
        content = content.replace(
            '"BITS-book-oasis2.dtd"',
            r'"https://jats.nlm.nih.gov/extensions/bits/2.0/BITS-book-oasis2.dtd"')
        content = content.replace(
            '"JATS-archive-oasis-article1-mathml3.dtd"',
            r'"https://jats.nlm.nih.gov/archiving/1.2d1/JATS-archive-oasis-article1-mathml3.dtd"')
        xslt = os.path.join(config.xsltdir, 'ACM.xslt')
        output = self.xsl_transform(content, xslt)

        now = datetime.now()
        outfile = now.strftime('%Y-%m-%d-%H%M%S') + '_ACM_Ingest.xml'
        self.outarchive.write_member(outfile, output)
        content = self.outarchive.read_member(outfile, encoding='utf-8')
        self.extract_subjects(content)
        self.qa_it(outfile)


if __name__ == '__main__':
    adir = os.path.join(config.testdir, 'ACM_test_data')
    a = ArchiveDirectory(adir)
    b = BatchACM(a)
    b.batchit()
    config.ui.message(b.outarchive.read_member('Ingest_Me.xml'))    
    b.outarchive.delete()