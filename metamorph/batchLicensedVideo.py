import os
from datetime import datetime, timezone
from io import BytesIO
import pymarc
from pymarc import exceptions as exc

from .archive import ArchiveDirectory
from .batch import Batch
from .xmldoc import Xmldoc
from . import config


class BatchLicensedVideo(Batch):
    def batchit(self):
        self.package()
        xml = None
        files = self.inarchive.glob('**/*.mrc')
        input_file = config.ui.multiple_choice(
            'Directory contains more than 1 MARC file\n' +
            'Which is the MARC file containing the metadata for ingest?',
            files)
        if not input_file:
            files = self.inarchive.glob('**/*.dat')
            input_file = config.ui.multiple_choice(
                'Directory contains more than 1 DAT file\n' +
                'Which is the DAT file containing the metadata for ingest?',
                files)
        if input_file:
            mrc = self.inarchive.read_member(input_file, binary=True)
            reader = pymarc.reader.MARCReader(mrc, to_unicode=True)
        else:
            files = self.inarchive.glob('**/*.mrk') 
            input_file = config.ui.multiple_choice(
                'Directory contains more than 1 MRK file\n' +
                'Which is the MRK file containing the metadata for ingest?',
                files)
            if input_file:
                mrc = self.inarchive.read_member(input_file, binary=False)
                reader = pymarc.reader.MARCMakerReader(mrc)
        if input_file:
            memory = BytesIO()
            writer = pymarc.writer.XMLWriter(memory)
            for record in reader:
                if record:
                    writer.write(record)
                elif isinstance(reader.current_exception, exc.FatalReaderError):
                    # data file format error
                    # reader will raise StopIteration
                    print(reader.current_exception)
                    print(reader.current_chunk)
                else:
                    # fix the record data, skip or stop reading:
                    print(reader.current_exception)
                    print(reader.current_chunk)
                    # break/continue/raise
            writer.close(close_fh=False)
            xml = memory.getvalue().decode('utf-8')
        else:
            files = self.inarchive.glob('**/*.xml')
            input_file = config.ui.multiple_choice(
                'Directory contains more than 1 DAT file\n' +
                'Which is the DAT file containing the metadata for ingest?',
                files)
            if input_file:
                xml = self.inarchive.read_member(input_file, binary=True)
                xml = xml.decode('utf-8')
            else:
                config.ui.message('No MARC files in this archive')
                return
        xdoc = Xmldoc(xml)
        xslt = os.path.join(config.xsltdir, 'licensed_video.xslt')
        output = xdoc.apply_xslt(xslt)
        name = self.username
        dt = datetime.now(timezone.utc).astimezone().isoformat()
        qr_note = "<tufts:qr_note>Metadata reviewed by: " + name + " on " + dt + "</tufts:qr_note>"
        xdoc2 = Xmldoc(output)
        output = xdoc2.replace_element('tufts:qr_note', qr_note)
        now = datetime.now()
        outfile = now.strftime('%Y-%m-%d-%H%M%S') + '_MARC_Ingest.xml'
        self.outarchive.write_member(outfile, output.encode(encoding='utf-8'))
        self.extract_subjects(output)
        self.qa_it(outfile)


if __name__ == '__main__':
    adir = os.path.join(config.testdir, 'Licensed_Video_test_data')
    a = ArchiveDirectory(adir)
    b = BatchLicensedVideo(a)
    b.batchit()
    config.ui.message(b.outarchive.read_member('Ingest_Me.xml'))    
    b.outarchive.delete()