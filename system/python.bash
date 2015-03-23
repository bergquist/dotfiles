if [ $(uname) = "Linux" ]
then
	alias http='python2 -m SimpleHTTPServer $1'
elif [[ $(uname) = "MINGW32_NT-6.2" ]]; then
	alias http='/c/tools/python2/python.exe -m SimpleHTTPServer $1'
else
	alias http='python -m SimpleHTTPServer $1'
fi
