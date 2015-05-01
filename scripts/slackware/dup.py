#!/usb/bin/python

from datetime import date
import requests
import re


class Pkgs(object):

    """ Class to handle Slackware security upgrades """

    root = "http://www.slackware.com/security/"
    lyear = "list.php?l=slackware-security&y="
    # 1st group = date, 3rd = relative_url, 4th = pkg_name
    expr = '<BR>(\w{4}(-\w{2}){2})[^"]+"([^"]+)">([^)]+\))'
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

    def getparse(self):
        """getparse:
            create a list of tuples
            [(date, relative_url, pkg_name),...]
            set it to self.pkgs variable
        """
        lines = getlines(root + lyear + str(self._date.year))
        self.pkgs = [(m.group(1), m.group(3), m.group(4))
                     for m in [re.search(expr, l)
                     for l in lines if "viewer.php" in l]]

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
        for p in self.pkgs:
            lines = getlines(root + p[1])
            # TODO: filter based on get and reject
            ftps = [re.search(xftp, l).group(0)
                    for l in lines if grep in l]
            for l in lines:
                for f in ftps:
                    if f.split('/')[-1] in l:
                        md5sums += re.search(xmd5, l).group(1)
            self.ftps += [(f, m) for f, m in zip(ftps, md5sums)]

    def getlines(self, url):
        """check_getlines:

        :url: resource url

        :returns: list of lines if no errors occured

        """
        response = requests.get(url)
        if response.status_code != requests.codes.ok:
            print "[X] Error " + str(requests.status_codes) + " in request"
            response.raise_for_status()
        return response.content.splitlines()

# EOF vim: set ts=4 sw=4 tw=80 :
