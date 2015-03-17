if [ $(uname -s ) == "MINGW32_NT-6.2" ]
then
	eval $(ssh-agent)
	ssh-add
fi