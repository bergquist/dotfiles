#!/usr/bin/python
import os
import sys
import commands

def subFolders():
  current_dir = os.getcwd();
  for child in os.listdir(current_dir):
    if os.path.isdir(child):
      yield os.path.join(current_dir, child)

def getDestination():
  if len(sys.argv) <= 1 or sys.argv[1]:
    return '/movies/'

  return sys.argv[1]

def getFirstrarefile(subchild):
  for rarfile in os.listdir(subchild):
    if rarfile.find('.rar') > 0:
      return os.path.join(subchild, rarfile)

def extract(rarfile):
  cmd = 'unrar e -kb ' + rarfile + ' ' + getDestination()
  print 'extracting ' + rarfile.split('/')[-1]
  commands.getstatusoutput(cmd)

for folder in subFolders():
  extract(getFirstrarefile(folder))