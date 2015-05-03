#!/usb/bin/python

# Module dependent
from datetime import date
import requests
import hashlib
from subprocess import call
import re

# Main dependent
import sys


class Pkgs(object):

    """ Class to handle Slackware security upgrades """

    root = "http://www.slackware.com/security/"

    lyear = "list.php?l=slackware-security&y="

    # 1st group = date, 3rd = relative_url, 4th = pkg_name
    expr = '<BR>(\w{4}(-\w{2}){2})[^"]+"([^"]+)">\[[^\s]+\s+([^)]+\))'

    xftp = 'ftp[^\s]+txz'

    xmd5 = '([a-f\d]{32})\s+([^\s]+txz)'

    def __init__(self, date=date.today(), get=[], reject=[]):
        """Init the object fields

        :date: default behaviour is to download only today upgrade
        :get: list of keyword to select pkgs that we want download
        :reject: list of keyword to reject pkgs contain them

        """
        self._date = date
        self._get = get
        self._reject = reject
        self.ftps = []
        self.getparse()

    def getparse(self):
        """getparse:
            create a list of tuples
            [(date, relative_url, pkg_name),...]
            set it to self.pkgs variable
        """
        lines = self.getlines(self.root + self.lyear + str(self._date.year))
        self.pkgs = [(self.getdateobj(m.group(1)), m.group(3), m.group(4))
                     for m in [re.search(self.expr, l)
                     for l in lines if "viewer.php" in l]]
        self.pkgs = filter(lambda p: p[0] >= self._date, self.pkgs)

    def ftpkgs(self, is64=True, version="current"):
        """ftpkgs:
            Iterate over self.pkgs and build a list of tuples
            [(ftp_url, md5sum),...]

        :is64: bool value that indicate arch (32bit or 64bit)
        :version: version number, default 'current' (other possible values are
        for example '14.0', '14.1')

        """
        grep = (str('slackware64-' + version) if is64 is True else
                str('slackware-' + version))
        ftpsingle = []
        for p in self.pkgs:
            lines = self.getlines(self.root + p[1])
            ftpsingle = [re.search(self.xftp, l).group(0)
                         for l in lines
                         # check the arch
                         if grep in l
                         # check if user want to download it
                         and True is reduce(lambda x, y:
                                            x or self.strhas(l, y), self._get,
                                            False if self._get else True)
                         # check if user want reject it, has priority if
                         # keyword is in _get and _reject, the pkg will be
                         # rejected
                         and False is reduce(lambda x, y:
                                             x or self.strhas(l, y),
                                             self._reject,
                                             False if self._reject else True)
                         ]
            md5single = [re.search(self.xmd5, l).group(1)
                         for l in lines
                         if re.search(self.xmd5, l) is not None
                         and True is reduce(lambda x, y:
                                            x or self.strhas(l,
                                                             y.split('/')[-1]),
                                            ftpsingle,
                                            False)
                         ]
            self.ftps.extend([(f.split('/')[-1], f, m)
                              for f, m in zip(ftpsingle, md5single)])

    def download_and_check(self):
        """download_and_check: Download packages filtered by ftpkgs function
        and check their md5sum

        :return: string informations
        """
        infos = ""
        # f[0] file_name f[1] ftp_url f[2] md5sum
        for f in self.ftps:
            call(["wget", f[1]])
            try:
                digest = hashlib.md5(open(f[0]).read()).hexdigest()
                info = "[i] " + f[0] + " md5sum "
                if f[2] == digest:
                    infos += info + "OK\n"
                else:
                    infos += info + "BAD\n"
            except Exception, e:
                infos += str(e) + "\n"
        return infos

    def getlines(self, url):
        """check_getlines:

        :url: resource url

        :returns: list of lines if no errors occured

        """
        print "[i] GET " + url
        response = requests.get(url)
        if response.status_code != requests.codes.ok:
            print "[X] Error " + str(requests.status_codes) + " in request"
            response.raise_for_status()
        return response.content.splitlines()

    def strhas(self, string, word):
        """strhas:self explained

        :string: whole string, where to search
        :word: what we want to find
        :returns: True if string has word False otherwise

        """
        return True if word in string else False

    def getdateobj(self, stringdate):
        """getdateobj: return a date type from a string YYYY-MM-DD

        :stringdate: self explain
        :returns: date object

        """
        ymd = map(lambda x: int(x), stringdate.split('-'))
        return date(ymd[0], ymd[1], ymd[2])


if __name__ == '__main__':
    if len(sys.argv) is 1:
        print "Auto mode, download only today updates"
        up = Pkgs()
        up.download_and_check()
        sys.exit(0)

    if sys.argv[1] == "-h" or sys.argv[1] == "--help":
        print "Usage: " + sys.argv[0] + \
              " [date=YYYY-MM-DD] [arch32] [ver=VERSION] " \
              "[get=LIST] [reject=LIST]"
        sys.exit(1)

    xdt = 'date=\w{4}(-\w{2}){2}'
    xver = 'ver=[^\s]+'
    xarc = ' arch32 '
    xget = 'get=[^\s]+'
    xrej = r'reject=[^\s]+'

    cmd = ' '.join(sys.argv)
    ymd = re.search(xdt, cmd)
    if ymd is not None:
        ymd = map(lambda x: int(x), ymd.group(0)[5:].split('-'))
        dt = date(ymd[0], ymd[1], ymd[2])
    else:
        dt = date.today()
    arch = False if re.search(xarc, cmd) is not None else True
    vers = re.search(xver, cmd)
    vers = vers.group(0)[4:] if vers is not None else "current"
    gets = re.search(xget, cmd)
    gets = gets.group(0)[4:].split(',') if gets is not None else []
    rejs = re.search(xrej, cmd)
    rejs = rejs.group(0)[7:].split(',') if rejs is not None else []

    up = Pkgs(dt, gets, rejs)
    up.ftpkgs(arch, vers)
    print up.download_and_check()
# EOF vim: set ts=4 sw=4 tw=80 :
