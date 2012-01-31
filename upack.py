#!/usr/bin/python
import os
import sys
import commands

movieDir = '/movies/'
currentDir = os.getcwd()
if len(sys.argv) > 1 and sys.argv[1] != None:
  movieDir = sys.argv[1]

for child in os.listdir(currentDir):
  if os.path.isdir(child):
    subchild = os.path.join(currentDir, child)
    for rarfile in os.listdir(subchild):
      if rarfile.find('.rar') > 0:
        cmd = 'unrar e -kb ' + os.path.join(subchild, rarfile) + ' ' + movieDir
        print cmd
        commands.getstatusoutput(cmd)
    
