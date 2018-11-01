# !/usr/bin/python3
import os
import sys
import hashlib
import tempfile
import subprocess
import hashlib

import tkinter

from tkinter import messagebox
from tkinter import Button
from tkinter import Text
from tkinter import Entry
from tkinter import filedialog
from tkinter import Label

filename = ""
title = ""
description = ""
category = ""
team = ""
s3Prefix = "https://s3.amazonaws.com/nist-sgcps/UCEF/"
s3url=""
md5=""
sha256=""
sha512=""
dustbin="\\\\dustbin\\nist-sgcps\\UCEF\\"

bufferSize = 1 * 1024 * 1024  # 1 MB



YAML = '''
- name: "{title}"
  description: "{description}"
  category: "{category}"
  url: {s3url}
  md5: {md5}
  sha512: {sha512}
  team: {team}
'''.strip()


def load_file():
    global filename
    file = filedialog.askopenfilename()
    filenametxt.delete(1.0, tkinter.END)
    filenametxt.insert(tkinter.END, file, "aaa")
    filename = file

def quitCallBack():
    global filename
    global title
    global description
    global category
    global team

    # retrieve results and then quit
    title = titletxt.get()
    description = descriptiontxt.get()
    category = categorytxt.get()
    team = teamtxt.get()
    filename = filenametxt.get(1.0, tkinter.END)
    top.destroy()

#def dialog(me):
# set up dialog contents
top = tkinter.Tk()
top.geometry("1200x500")

######
# Banner
######
b = Label(top, height=2, text="Enter Description and File to Upload")
b.pack()

######
# FILE
######
F = Button(top, text="File", command=load_file)
F.place(x=50, y=100)
filenametxt = Text(top, height=1)
# T.insert( tkinter.END, "Just a Text widget","aaa")
filenametxt.pack()
filenametxt.place(x=200, y=100)

######
# Title
######
titleprompt = Text(top, height=1, width=30)
titleprompt.insert(tkinter.END, "Enter Title: ", "aaa")
titleprompt.pack()
titleprompt.place(x=50, y=150)
titletxt = Entry(top, width=80)
titletxt.pack()
titletxt.delete(0, tkinter.END)
titletxt.insert(0, "title goes here")
titletxt.place(x=200, y=150)
title=titletxt.get

######
# Description
######
descriptionprompt = Text(top, height=1, width=30)
descriptionprompt.insert(tkinter.END, "Enter description: ", "aaa")
descriptionprompt.pack()
descriptionprompt.place(x=50, y=200)
descriptiontxt = Entry(top, width=100)
descriptiontxt.pack()
descriptiontxt.delete(0, tkinter.END)
descriptiontxt.insert(0, "description goes here")
descriptiontxt.place(x=200, y=200)

######
# category
######
categoryprompt = Text(top, height=1, width=30)
categoryprompt.insert(tkinter.END, "Enter category: ", "aaa")
categoryprompt.pack()
categoryprompt.place(x=50, y=250)
categorytxt = Entry(top)
categorytxt.pack()
categorytxt.delete(0, tkinter.END)
categorytxt.insert(0, "category goes here")
categorytxt.place(x=200, y=250)

######
# Team
######
teamprompt = Text(top, height=1, width=30)
teamprompt.insert(tkinter.END, "Enter team: ", "aaa")
teamprompt.pack()
teamprompt.place(x=50, y=300)
teamtxt = Entry(top)
teamtxt.pack()
teamtxt.delete(0, tkinter.END)
teamtxt.insert(0, "team goes here")
teamtxt.place(x=200, y=300)

Q = Button(top, text="Upload", command=quitCallBack)
Q.place(x=50, y=400)

#top.mainloop()
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

def doYml():
    yml = YAML.format(
        title=title, description=description, category=category, s3url=s3url,
        md5=md5, sha512=sha512, team=team)
    print(yml)


def main():
    global filename
    global title
    global description
    global category
    global team
    global md5
    global sha512

    top.mainloop()

    print("Computing hashes .....")

    (md5, sha512) = HashAndScan(filename.rstrip())

    destinationFileLocation = filename.rstrip().split("files/")[1]
    destinationFileLocation = destinationFileLocation.replace("files/","")
    destinationFileLocation = destinationFileLocation.replace("\\","/")
    s3url = s3Prefix + destinationFileLocation

    yml = YAML.format(
        title=title, description=description, category=category, s3url=s3url.rstrip(),
        md5=md5, sha512=sha512, team=team)
    print(yml)

    with open("_data/documents.yml","a") as doc:
        doc.write(yml)
        doc.write("\n")

    print("Copying file .....")

    cmd="cp " + filename.rstrip() + " " + dustbin + destinationFileLocation
    subprocess.call(cmd,shell=True)

    print("done!")

if __name__ == '__main__':
    main()