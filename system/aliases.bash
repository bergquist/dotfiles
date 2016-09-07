# grc overides for ls
#   Made possible through contributions from generous benefactors like
#   `brew install coreutils`


if [ $(gls &>/dev/null) ]
then
  alias ls="gls -F --color"
  alias l="gls -lAh --color"
  alias ll="gls -l --color"
  alias la='gls -A --color'
fi

if [ $(uname -s ) == "MINGW32_NT-6.2" ]
then
	alias ls='ls --color'
fi

if [ $(uname -s ) == "Linux" ]
then
	alias ls='ls --color'
	alias la='ls --color --all'
	alias l='ls --color'
fi

alias grep="grep --color=auto"

# View HTTP traffic
if [ $(uname -s ) == "Darwin" ]
then
	alias sniff="sudo ngrep -d 'en1' -t '^(GET|POST) ' 'tcp and port 80'"
	alias httpdump="sudo tcpdump -i en1 -n -s 0 -w - | grep -a -o -E \"Host\: .*|GET \/.*\""
fi

if [ $(uname -s ) == "Linux" ]
then
	alias sniff="sudo ngrep -d 'eth0' -t '^(GET|POST) ' 'tcp and port 80'"
	alias httpdump="sudo tcpdump -i eth0 -n -s 0 -w - | grep -a -o -E \"Host\: .*|GET \/.*\""
fi

# OS X has no `md5sum`, so use `md5` as a fallback
command -v md5sum > /dev/null || alias md5sum="md5"

# Lock the screen (when going AFK)
alias afk="/System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend"

alias renewip="sudo ipconfig set en0 BOOTP && sudo ipconfig set en0 DHCP"

function mkcd () { mkdir -p "$@" && cd "$@"; }

alias cdgf="cd ~/dev/go/src/github.com/grafana/grafana"
alias cdgfc="cd ~/dev/go/src/github.com/grafana/grafana-cli"
alias gd='git diff --color | sed -E "s/^([^-+ ]*)[-+ ]/\\1/" | less -r'
