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
        fullPath = os.path.join(subchild, rarfile)
        cmd = 'unrar e -kb ' + fullPath + ' ' + movieDir
        print 'extracting ' + fullPath.split('/')[-1]
        commands.getstatusoutput(cmd)
    
