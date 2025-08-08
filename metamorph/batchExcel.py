import os
from datetime import datetime
import io
import re
import pandas

from .batch import Batch
from .archive import ArchiveDirectory
from .xmldoc import Xmldoc
from . import config
from . import mira_config



class BatchExcel(Batch):
    def batchit(self):
        choices = {'Faculty Scholarship': 'Faculty',
                   'Student Scholarship': 'Student',
                   'Trove': 'Trove',
                   'Music Concert Programs': 'Concert',
                   'SMFA Artist Books': 'SMFA',
                   'Jordan Nutrition Innovation Lab': 'Jordan',
                   'Food Systems Innovation Lab': 'FoodSystems',
                   'Nutrition Innovation Lab (Original)': 'Nutrition'}
        choicename =config.ui.multiple_choice(
            'What type of Excel submission?', choices.keys())
        process = choices[choicename]
        
        self.package()        
        files = self.outarchive.glob('excel/*.xlsx')
        if len(files) > 1:
            config.ui.message('\nDirectory contains more than 1 XLSX file')
            xlsx = config.ui.multiple_choice('Which is the XLSX file containing the metadata for ingest?', files)
        else:
            excel = files[0]
        config.ui.message(['input file =', excel])
        xsl = self.outarchive.read_member(excel, binary=True)
        
        metadata = pandas.read_excel(
            io.BytesIO(xsl), dtype=str, na_values=[""])
        metadata.rename(columns=mira_config.normalize_excel, inplace=True)
        for col in metadata.columns:
            metadata[col] = metadata[col].str.replace("“", '"')
            metadata[col] = metadata[col].str.replace("”", '"')
            metadata[col] = metadata[col].str.replace("’", "'")
            metadata[col] = metadata[col].str.replace("‘", "'")
        metadata['Process'] = process
        metadata['Filename'] = metadata['Filename'].str.replace(" ", "_")
        metadata['Filename'] = metadata['Filename'].str.replace(".", "_")
        pattern = r'_(mp4|mp3|tif|jpg|gif|mov|wav|pdf)$'
        compiled = re.compile(pattern)
        metadata['Filename'] = metadata['Filename'].str.replace(r"_mp4$", ".mp4", regex=True)
        metadata['Filename'] = metadata['Filename'].str.replace(r"_mp3$", ".mp3", regex=True)
        metadata['Filename'] = metadata['Filename'].str.replace(r"_tif$", ".tif", regex=True)
        metadata['Filename'] = metadata['Filename'].str.replace(r"_jpg$", ".jpg", regex=True)
        metadata['Filename'] = metadata['Filename'].str.replace(r"_gif$", ".gif", regex=True)
        metadata['Filename'] = metadata['Filename'].str.replace(r"_mov$", ".mov", regex=True)
        metadata['Filename'] = metadata['Filename'].str.replace(r"_wav$", ".wav", regex=True)
        metadata['Filename'] = metadata['Filename'].str.replace(r"_pdf$", ".pdf", regex=True)
        xml = metadata.to_xml(root_name='root', index=False)
        xdoc = Xmldoc(xml)
        xslt = os.path.join(config.xsltdir, 'excel_to_dc.xslt')
        output = xdoc.apply_xslt(xslt)
        output = output.encode(encoding='utf-8')
        now = datetime.now()
        outfile = now.strftime('%Y-%m-%d-%H%M%S') + '_Excel_Ingest.xml'
        self.outarchive.write_member(outfile, output)
        content = self.outarchive.read_member(outfile)
        self.extract_subjects(content)
        self.qa_it(outfile)


if __name__ == '__main__':
    adir = os.path.join(config.testdir, 'Faculty_Scholarship_test_data')
    a = ArchiveDirectory(adir)
    b = BatchExcel(a)
    b.batchit()
    b.outarchive.delete()