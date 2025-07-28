import os

from .interface import Interface

ui = Interface()
xsltdir = os.path.join(os.path.dirname(__file__), '..', 'xslt')
testdir = os.path.join(os.path.dirname(__file__), '..', 'test_samples')