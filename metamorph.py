#!/usr/bin/env python

from metamorph import config
from metamorph.batch import Batch
from metamorph.batchACM import BatchACM
from metamorph.batchExcel import BatchExcel
from metamorph.batchInHouse import BatchInHouse
from metamorph.batchLicensedPDF import BatchLicensedPDF
from metamorph.batchLicensedVideo import BatchLicensedVideo
from metamorph.batchProQuest import BatchProQuest
from metamorph.batchSpringer import BatchSpringer


choices = {
    'Excel Metadata': BatchExcel,
    'Proquest ETDs': BatchProQuest,
    'Springer Open Access Articles': BatchSpringer,
    'ACM Open Access Articles': BatchACM,
    'Digitized Book (In-House)': BatchInHouse,
    'Video (Licensed)': BatchLicensedVideo,
    'PDF (Licensed)': BatchLicensedPDF,
    'Quit': 'quit'
    }

while True:
    choicename = config.ui.multiple_choice(
        '\nWhat would you like to do?', choices.keys())
    
    if choicename == 'Quit':
        break
    else:
        with choices[choicename]() as batch:
            batch.batchit()
        
