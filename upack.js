#!/usr/bin/env node
  
var path = require('path'),
    fs = require('fs');
    util = require('util');
    exec = require('child_process').exec;
 
var args = process.argv.slice(2);
var unzipdir = '/home/yobo';

if (args.length > 0) {
  if (path.existsSync(args[0])) {
    unzipdir = args[0];
  }
} 

var dirs = fs.readdirSync(process.cwd());

dirs.filter(function(dir) {
  if (isValidDir(dir)) {
    var p = path.join(process.cwd(), dir);
    var subdirs = fs.readdirSync(p);
    subdirs.filter(function(subdir) {
      if  (path.extname(subdir) === ".rar") {
	unrarfile(path.join(dir, subdir));	
      }
    });
  }
});

function unrarfile(filePath) {
  var line = "unrar e " + filePath + " " + unzipdir;
  child = exec(line, function(error, stdout, stderr) {
    if (error !== null) {
      console.log('Finnished unraring: ' + filePath);
     } else {
       console.log(stderr);
       console.log(stderr);
     }
  );
}

function isValidDir(dir) {
  var stat = fs.statSync(path.join(process.cwd(), dir));
  var isDir = stat.isDirectory();
  isDir = isDir && dir[0] !== '.';

  return isDir
}






