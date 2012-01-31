#!/usr/local/bin/python
import os
import sys
import commands

movieDir = '/movies/'
currentDir = os.getcwd()
if sys.argv[0] != None:
  movieDir = sys.argv[0]

for child in os.listdir(currentDir):
  if os.path.isdir(child):
    subchild = os.path.join(currentDir, child)
    for rarfile in os.listdir(subchild):
      if rarfile.find('.rar') > 0:
        cmd = 'unrar x -inul -y ' + os.path.join(subchild, rarfile) + ' ' + movieDir
        commands.getstatusoutput(cmd)
    
