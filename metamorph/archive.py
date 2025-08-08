# = archive.rb
#
# This program is free software.
# You can distribute/modify this program under the same terms as python.
#
# == class Archive
#
# Objects of class +Archive+ represent sets of data to be ingested
# into a repository. An +Archive+ includes both the items to be
# ingested (e.g. images, PDFs, etc.) and the metadata describing the
# items (XML, MARC, JSON, Excel, etc.).
#
# Currently, an +Archive+ can be in the form of a directory of files
# (+ArchiveDirectory+). Other extensions may added in the future.
#
# An +Archive+ object can be created for reading or for writing.  The
# usual process is to create a read-only +Archive+ representing the
# data as delivered (the input), and a second write-only +Archive+
# for the processed data (the output), organized and transformed as
# necessary for ingest into the local repository.
#
# A member of an Archive is any node which is a descendant of the root
# of the Archive. Methods enable globbing, reading members, writing
# members, and copying members from one +Archive+ to another +Archive+.
# The root of an +Archive+ is the filepath to the top level of the
# +Archive+.
#
# The scope of +Archive+ methods is limited to members of an +Archive+.
# +Archive+ methods cannot read or write any files or directories which
# are not a member of an +Archive+. A writable +Archive+ cannot be
# constructed on a root filepath which already exists.  Thus, an
# +Archive+ cannot edit any previously existing data; it can only copy
# existing data or create new data, and only within the confines of
# an +Archive+.
import os
from os import path
import subprocess
import platform
import time
import shutil
import glob
import codecs


class Archive:
    _root = ''
    _mode = ''
    
    def __init__(self, root, mode='r'):
        self._root = root
        self._mode = mode
    
    def __str__(self):
        return(' '.join(['Archive: ', self._root]))
    
    def getroot(self):
        return self._root
    
    def getmode(self):
        return self._mode


class ArchiveDirectory(Archive):
    def __init__(self, root, mode='r'):
        root = os.path.realpath(root)
        if mode == 'r':
            if os.path.exists(root):
                Archive.__init__(self, root, mode)
            else:
                raise FileNotFoundError(
                    'Path to Archive does not exist')
        elif mode == 'w':
            if os.path.exists(root):
                raise PermissionError(
                    'Archive already exists, cannot be opened for writing')
            else:
                Archive.__init__(self, root, mode)
                self.mkbranch(root)
        else:
            raise PermissionError(
                'Unknown permission mode')

    def _pathto(self, relpath):
        fullpath = os.path.join(self.getroot(), relpath)
        return os.path.realpath(fullpath)
    
    def ismember(self, relpath):
        fullpath = self._pathto(relpath)
        prefix = os.path.commonprefix([self.getroot(), fullpath])
        return prefix==self.getroot()
    
    def isdir(self, relpath):
        fullpath = self._pathto(relpath)
        if not self.ismember(fullpath):
            raise PermissionError(
                'Path specifies a location outside the Archive')
        return os.path.isdir(fullpath)
    
    def exists(self, relpath):
        fullpath = self._pathto(relpath)
        if not self.ismember(fullpath):
            raise FileNotFoundError(
                'Path specifies a location outside the Archive')
        return os.path.exists(fullpath)
    
    def launch(self, relpath):
        fullpath = self._pathto(relpath)
        if not self.ismember(fullpath):
            raise FileNotFoundError(
                'Path specifies a location outside the Archive')
        system = platform.system()
        if system == 'Windows':
            subprocess.Popen('start ' + fullpath, shell=True)
        if system == 'Darwin' or system == 'Linux':
            subprocess.Popen('open ' + fullpath, shell=True)
    
    def delete(self):
        if self.getmode() == 'w':
            shutil.rmtree(self.getroot())
        else:
            raise PermissionError(
                'Cannot delete a read-only Archive')
        
    def glob(self, relpath):
        result = []
        for f in glob.iglob(relpath, root_dir=self.getroot(), recursive=True):
            fullpath = self._pathto(f)
            if self.ismember(fullpath):
                result.append(f)
        return result
    
    def read_member(self, relpath, binary=False, encoding=None):
        fullpath = self._pathto(relpath)
        if not self.ismember(fullpath):
            raise PermissionError(
                'Path specifies a location outside the Archive')
        if binary:
            file = open(fullpath, 'rb')
        else:
            file = codecs.open(fullpath, 'r', encoding=encoding)
        contents = file.read()
        file.close()
        return contents
        
    def write_member(self, relpath, contents):
        if self.getmode() != 'w':
            raise PermissionError(
                'Archive is not in write mode')
        fullpath = self._pathto(relpath)
        if self.exists(fullpath):
            raise PermissionError(
                'File already exists')
        if isinstance(contents, str):
            file = open(fullpath, 'w')
        elif isinstance(contents, bytes):
            file = open(fullpath, 'wb')
        file.write(contents)
        file.close()
    
    def copy_member(self, src, dest_archive, dest):
        contents = self.read_member(src, binary=True)
        dest_archive.write_member(dest, contents)
    
    def copy_members(self, sources, dest_archive, destdir):
        for entry in sources:
            if self.isdir(entry):
                dest_archive.mkdir(entry)
            else:
                self.copy_member(entry, dest_archive, entry)
    
    def mkbranch(self, relpath):
        if self.getmode() != 'w':
            raise PermissionError(
                'Archive is not in write mode')
        fullpath = self._pathto(relpath)
        if not self.ismember(fullpath):
            raise PermissionError(
                'Path specifies a location outside the Archive')
        os.makedirs(fullpath)


if __name__ == '__main__':
    import os
    from . import config
    topdir = os.path.join(os.path.dirname(__file__), '..')
    
    a = ArchiveDirectory(topdir)
    print(a)
    print(a.getroot())
    print(a.getmode())
    print(a.ismember(os.path.join(topdir, '..')))
    print(a.ismember(os.path.dirname(__file__)))
    print(a.glob('**'))
    print(a.exists('archive.py'))
    print(a.isdir('.'))
    b = ArchiveDirectory(os.path.join(topdir, 'temp', 'w'))
    a.copy_members(['batch.py', 'interface.py'], b, 'temp')
    print(b.exists('interface.py'))
    print(b.getroot())
    b.delete()