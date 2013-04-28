#!/usr/bin/python
import os
import sys
import commands

def subFolders(current_dir):
  for child in os.listdir(current_dir):
    if os.path.isdir(child):
      yield os.path.join(current_dir, child)

def firstRarefile(subchild):
  for rarfile in os.listdir(subchild):
    if rarfile.find('.rar') > 0:
      return os.path.join(subchild, rarfile)

def extract(rarfile, destination):
  #print 'extracting ' + rarfile.split('/')[-1]
  cmd = 'unrar e -kb ' + rarfile + ' ' + destination
  print cmd
  commands.getstatusoutput(cmd)

def main(current_dir, destination):
  for folder in subFolders(current_dir):
    filepath = firstRarefile(folder)
    extract(os.path.join(current_dir, filepath), destination)

destination = '/movies/'
if len(sys.argv) > 1 and sys.argv[1] is not None:
  destination = sys.argv[1]

if __name__ == '__main__':
  main(os.getcwd(), destination)