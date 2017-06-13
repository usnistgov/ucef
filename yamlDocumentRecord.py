#!/usr/bin/env python
#
# yamlDocumentRecord <filename> <title> <description> <category> <team>
#
# where
# <filename> is a filename to use
# <title> is title
# <description> is description
# <category> is one of "document" | "presentation" | "TEapproach" |
#     "standard" | "video" | ""
# <team> is a team mnemonic string we will create and use
#
# Writes a yaml stanza to standard output describing the input file.  The
# stanza will look like this:
#
# Here is the proposed yaml file structure which is an update to the current;
# - name: "the title string of the presentation"
#   description: "a description"
#   category: ["document" | "presentation" | "TEapproach" | "standard" |
#       "video" | ""]
#   url: "<url to acquire document>"
#   md5: md5 checksum
#   sha256: sha256 checksum
#   team: UCEF Team id -- UCEF for all
#   featured: true (if item should be featured)
#
# Here is a sample record (you only need to populate these variables could be
# command line arguments:
# - name: "<name>"
#   description: "<description>"
#   category: <category>
#   url: <s3 URL>
#   md5: <md5>
#   sha256: <sha256>
#   team: <team>
#
# You can generate the url from the filename and the S3 prefix string
# .../NIST-SGCPS/UCEF/<filename> and the checksums from the file,
# of course.
#

# 2015/09/25 steveb@nist.gov
# First implementation
# Note that this script assumes that an on-access virus scanner is running,
# and that writing a file to /tmp will cause it to be scanned.  (I did not
# want to assume that reading from an arbitrary file would allow it to be
# scanned since I have heard of cases where scanners do not run on network
# drives.)  I use tempfile.NamedTemporaryFile to do this since it will
# generate a secure file on disk and automatically remove it on exit.
# NOTE that an assumption is that the virus scanner will pop up a window
# if a virus is found, and the user will notice this!

# 2015/09/25 tnc@nist.gov
# Made a few changes:
#   - Add missing parentheses to `usage` calls
#   - Allow empty category strings
#   - Make Python3 compatible, esp. in reading file chunks
#   - Change formatting to assuage flake8 complaints

# 2015/09/28 tnc@nist.gov
# Use byte literal to check EOF condition, replacing do-while file reading.

from __future__ import print_function
import os
import sys
import hashlib
import tempfile
import subprocess

import initializeCredentials

s3Prefix = "https://s3.amazonaws.com/nist-sgcps/UCEF/"
bucket = "nist-sgcps/UCEF/"

validCategories = set(
    ['document', 'presentation', 'standard', 'video', ''])

bufferSize = 1 * 1024 * 1024  # 1 MB


def HashAndScan(name):
    md5hash = hashlib.md5()
    sha512hash = hashlib.sha512()
    with open(name, "rb") as f:
        with tempfile.NamedTemporaryFile() as t:
            for chunk in iter(lambda: f.read(bufferSize), b''):
                t.write(chunk)
                md5hash.update(chunk)
                sha512hash.update(chunk)
    return (md5hash.hexdigest(), sha512hash.hexdigest())


USAGE = '''
Usage: %s filename title description category team
   <filename> is a filename to use
   <title> is title
   <description> is description
   <category> is one of "document" | "presentation" | "TEapproach" |
        "standard" | "video" | ""
   <team> is a team mnemonic string we will create and use
'''

YAML = '''
- name: "{title}"
  description: "{description}"
  category: "{category}"
  url: {s3url}
  md5: {md5}
  sha512: {sha512}
  team: {team}
'''.strip()


def usage():
    print(USAGE % (sys.argv[0],))
    sys.exit(1)


def main():
    if len(sys.argv) != 6:
        usage()

    # yamlDocumentRecord <filename> <title> <description> <category> <team>
    (filename, title, description, category, team) = sys.argv[1:6]

    if not (filename and title and description and team):
        usage()

    if category not in validCategories:
        print("Error: unknown category \"%s\"\n" % (category,))
        usage()

    if not os.path.exists(filename):
        print("Error: filename %s not found\n" % (filename,))
        usage()

    (md5, sha512) = HashAndScan(filename)

    destinationFileLocation = filename
    destinationFileLocation = destinationFileLocation.replace("files/","")
    destinationFileLocation = destinationFileLocation.replace("\\","/")
    s3url = s3Prefix + destinationFileLocation

    yml = YAML.format(
        title=title, description=description, category=category, s3url=s3url,
        md5=md5, sha512=sha512, team=team)
    print(yml)


    recordOk =  str(raw_input ("Is record OK? Y/N :"))
    print ("recordOk %s\n" % (recordOk,))
    if recordOk == 'Y' :
        print ("Check Credentials for AWS Access")
        if (initializeCredentials.checkAccess() != 0) :
            initializeCredentials.initializeCredentials()

        with open("_data/documents.yml","a") as doc:
            doc.write("\n")
            doc.write(yml)

        # copy file up to aws s3
        cmd = 'aws --profile=saml s3 cp ' + filename + ' s3://' + bucket + destinationFileLocation
        print ('cmd = ' + cmd)

        subprocess.call(cmd,shell=True)

if __name__ == '__main__':
    main()
