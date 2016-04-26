#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""

Author:     Giacomo Mantani
Github:     https://github.com/jak3

Version:    2.0

Description:

    Help update your slackware system checking, parsing and
    downloading updates from Slackware Linux Security Advisories.

Copyright © 2016 Giacomo Mantani

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the "Software"),
to deal in the Software without restriction, including without limitation
the rights to use, copy, modify, merge, publish, distribute, sublicense,
and/or sell copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included
in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

"""

from datetime import date, datetime
from subprocess import call
import argparse
import hashlib
import os.path
import re
import requests


class Pkgs(object):

    """ Class to handle Slackware security upgrades """

    fname_with_date = 'lastupdate'

    root = "http://www.slackware.com/security/"

    lyear = "list.php?l=slackware-security&y="

    # 1st group = date, 3rd = relative_url, 4th = pkg_name
    expr = r'<BR>(\w{4}(-\w{2}){2})[^"]+"([^"]+)">\[[^\s]+\s+([^)]+\))'

    xftp = r'ftp[^\s]+txz'

    xmd5 = r'([a-f\d]{32})\s+([^\s]+txz)'


    # Refactoring only data as parameter, other should be setted
    # def __init__(self, data=date.today(), get=[], reject=[]):
    def __init__(self, from_date=None, get=None, reject=None):
        """ Init the object fields

        :from_date: default behaviour is to download only today upgrade
        :get:       list of keyword in pkg name ( if true download )
        :reject:    list of keyword in pkg name ( if true discard  )

        """

        self._get = [] if get == None else get
        self._reject = [] if reject == None else reject
        self.ftps = []
        self.pkgs = []

        if from_date == None:
            if os.path.isfile(self.fname_with_date):
                with open(self.fname_with_date, 'r+') as fsdate:
                    # get previous date
                    self._date = self.getdateobj(fsdate.readline())
                    # overwrite with today
                    fsdate.write(date.today().isoformat())
                    fsdate.close()
            else:
                print "[i] First run, update from today advisory only.\n"
                self._date = date.today()
        else:
            self._date = from_date

        print "[i] Update from : " + str(self._date)

        # use persistance
        with open(self.fname_with_date, 'w') as fsdate:
            fsdate.write(date.today().isoformat())
            fsdate.close()

        self.getparse()

    def getparse(self):
        """ getparse:

            create a list of tuples
            [(date, relative_url, pkg_name),...]
            set it to self.pkgs variable
        """
        lines = self.getlines(self.root + self.lyear + str(self._date.year))
        self.pkgs = [(self.getdateobj(m.group(1)), m.group(3), m.group(4))
                     for m in [re.search(self.expr, l)
                               for l in lines if "viewer.php" in l]]
        # filter data, I prefer using filter + lambda but pylint dictate
        self.pkgs = [p for p in self.pkgs if p[0] >= self._date.date()]
        # filter get
        if self._get:
            self.pkgs = [p for p in self.pkgs if self.is_in_get(p[2])]
        # filter reject
        if self._reject:
            self.pkgs = [p for p in self.pkgs if self.is_in_reject(p[2])]

    def ftpkgs(self, arch="64", version="current"):
        """ ftpkgs:

            Iterate over self.pkgs and build a list of tuples
            [(ftp_url, md5sum),...]

            :arch: 32 or 64 (bit)
            :version: version number, default 'current' (or '14.1', '14.2')
        """
        grep = (str('slackware64-' + version) if arch == "64" else
                str('slackware-' + version))
        ftpsingle = []

        for pkg in self.pkgs:

            lines = self.getlines(self.root + pkg[1])

            ftpsingle = [re.search(self.xftp, l).group(0)
                         for l in lines
                         # check the arch
                         if grep in l]

            pkgname = ftpsingle[0].split('/')[-1]

            md5single = [re.search(self.xmd5, l).group(1)
                         for l in lines
                         if l and re.search(self.xmd5, l) is not None and
                         pkgname in re.search(self.xmd5, l).group(2)]

            # create [(ftp_url, md5sum),...]
            self.ftps.extend([(f.split('/')[-1], f, m)
                              for f, m in zip(ftpsingle, md5single)])

    def download_and_check(self):
        """ download_and_check: Download packages filtered by ftpkgs function
                                and check their md5sum

            :return: string informations
        """
        infos = ""
        # f[0] file_name f[1] ftp_url f[2] md5sum
        for url in self.ftps:
            call(["wget", url[1]])
            try:
                digest = hashlib.md5(open(url[0]).read()).hexdigest()
                info = "[i] " + url[0] + " md5sum "
                if url[2] == digest:
                    infos += info + "OK\n"
                else:
                    infos += info + "BAD\n"
            except OSError, conne:
                infos += str(conne) + "\n"
        return infos

    @classmethod
    def getlines(cls, url):
        """ getlines:

            :url: resource url

            :returns: list of lines if no errors occured
        """
        print "[i] GET " + url
        response = requests.get(url)
        if response.status_code != requests.codes[r'\o/']:
            print "[X] Error " + str(requests.status_codes) + " in request"
            response.raise_for_status()
        return response.content.splitlines()

    def is_in_get(self, string):
        """is_in_get:self explained

        :string: whole string, where to search
        :returns: True if string has a word in _get, False otherwise

        """
        for word in self._get:
            if word in string:
                return True
        return False

    def is_in_reject(self, string):
        """ is_in_reject: self explained

            :string: whole string, where to search

            :returns: True if string has a word in _reject, False otherwise
        """
        for word in self._reject:
            if word in string:
                return False
        return True

    @classmethod
    def getdateobj(cls, stringdate):
        """ getdateobj: return a date type from a string YYYY-MM-DD

            :stringdate: self explain
            :returns: date object
        """
        # I prefer map but let pylint dictate a more pythonic style
        ymd = [int(x) for x in stringdate.split('-')]
        return date(ymd[0], ymd[1], ymd[2])


def valid_date(sdate):
    """ valid_date: check if input date is valid

        :sdate: string date
    """
    try:
        return datetime.strptime(sdate, "%Y-%m-%d")
    except ValueError:
        msg = "Not a valid date: '{0}'.".format(sdate)
        raise argparse.ArgumentTypeError(msg)

if __name__ == '__main__':
    PARSER = argparse.ArgumentParser(
        description='Update slackware from official security advisories.')
    PARSER.add_argument('-d', '--date',
                        nargs='?', default=date.today(), type=valid_date,
                        help='from which date starting the update, default\
                                today',
                        metavar='Year-month-day')
    PARSER.add_argument('-x', '--x',
                        nargs='?', default="64", choices=['32', '64'],
                        help='architecture, default "64"',
                        metavar='NN')
    PARSER.add_argument('-v', '--version',
                        nargs='?', default="current",
                        help='slackware version (14.1, 14.2 ..), \
                                default "current"')
    PARSER.add_argument('-g', '--get',
                        nargs='*',
                        help='download packages with keywords in name')
    PARSER.add_argument('-r', '--reject',
                        nargs='*',
                        help='reject packages with keywords in name')

    ARGS = PARSER.parse_args()

    UP = Pkgs(ARGS.date, ARGS.get, ARGS.reject)
    UP.ftpkgs(ARGS.x, ARGS.version)
    print UP.download_and_check()

# EOF vim: set ts=4 sw=4 tw=80 :
