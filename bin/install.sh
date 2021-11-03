 #!/bin/bash
set -e
set -o pipefail

# install.sh
#	This script installs my basic setup for a debian laptop

export DEBIAN_FRONTEND=noninteractive

# Choose a user account to use for this installation
get_user() {
	if [ -z "${TARGET_USER-}" ]; then
		PS3='Which user account should be used? '
		options=($(find /home/* -maxdepth 0 -printf "%f\n" -type d))
		select opt in "${options[@]}"; do
			readonly TARGET_USER=$opt
			break
		done
	fi
}

check_is_sudo() {
	if [ "$EUID" -ne 0 ]; then
		echo "Please run as root."
		exit
	fi
}


setup_sources_min() {
	sudo apt-get update
	sudo apt-get install -y \
		apt-transport-https \
		ca-certificates \
		curl \
		dirmngr \
		lsb-release \
		--no-install-recommends

	# neovim
	cat <<-EOF | sudo tee /etc/apt/sources.list.d/neovim.list
	deb http://ppa.launchpad.net/neovim-ppa/unstable/ubuntu xenial main
	deb-src http://ppa.launchpad.net/neovim-ppa/unstable/ubuntu xenial main
	EOF

	# add the neovim ppa gpg key
	sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 9DBB0BE9366964F134855E2255F96FCF8231B6DD
}

# sets up apt sources
# assumes you are going to use debian buster
setup_sources() {
	setup_sources_min;

	#sudo cat <<-EOF > /etc/apt/sources.list
	# newer versions of the distribution.
	#deb http://se.archive.ubuntu.com/ubuntu/ xenial main restricted

	## Major bug fix updates produced after the final release of the
	#deb http://se.archive.ubuntu.com/ubuntu/ xenial-updates main restricted

	#deb http://se.archive.ubuntu.com/ubuntu/ xenial universe
	#deb http://se.archive.ubuntu.com/ubuntu/ xenial-updates universe

	#deb http://se.archive.ubuntu.com/ubuntu/ xenial multiverse
	#deb http://se.archive.ubuntu.com/ubuntu/ xenial-updates multiverse

	#deb http://se.archive.ubuntu.com/ubuntu/ xenial-backports main restricted universe multiverse

	## Uncomment the following two lines to add software from Canonical's
	# deb http://archive.canonical.com/ubuntu xenial partner
	# deb-src http://archive.canonical.com/ubuntu xenial partner

	#deb http://security.ubuntu.com/ubuntu xenial-security main restricted
	#deb http://security.ubuntu.com/ubuntu xenial-security universe
	#deb http://security.ubuntu.com/ubuntu xenial-security multiverse

	# yubico
	#deb http://ppa.launchpad.net/yubico/stable/ubuntu xenial main
	#deb-src http://ppa.launchpad.net/yubico/stable/ubuntu xenial main

	# tlp: Advanced Linux Power Management
	# http://linrunner.de/en/tlp/docs/tlp-linux-advanced-power-management.html
	#deb http://repo.linrunner.de/debian sid main
	#EOF

	# Create an environment variable for the correct distribution
	#CLOUD_SDK_REPO="cloud-sdk-$(lsb_release -c -s)"
	CLOUD_SDK_REPO="cloud-sdk-xenial"
	export CLOUD_SDK_REPO

	# Add the Cloud SDK distribution URI as a package source
	echo "deb http://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" | sudo tee /etc/apt/sources.list.d/google-cloud-sdk.list
	# Import the Google Cloud Platform public key
	curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -

	# Add the Google Chrome distribution URI as a package source
	echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" | sudo tee /etc/apt/sources.list.d/google-chrome.list
	curl https://dl.google.com/linux/linux_signing_key.pub | sudo apt-key add -

	# Add vscode keys
    echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" | sudo tee /etc/apt/sources.list.d/vscode.list
	curl -sSL https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -

	# Add azure cli
	curl -sL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/microsoft.gpg > /dev/null
	
	AZ_REPO=$(lsb_release -cs)
	echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" |
    sudo tee /etc/apt/sources.list.d/azure-cli.list

	#yarn repo and key
	echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
	curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -

	# Nodejs
	VERSION=node_12.x
	echo "deb https://deb.nodesource.com/$VERSION $(lsb_release -s -c) main" | sudo tee /etc/apt/sources.list.d/nodesource.list
	echo "deb-src https://deb.nodesource.com/$VERSION $(lsb_release -s -c) main" | sudo tee -a /etc/apt/sources.list.d/nodesource.list
	curl -sSL https://deb.nodesource.com/gpgkey/nodesource.gpg.key | sudo apt-key add -

	# Dropbox
	#echo "deb [arch=i386,amd64] http://linux.dropbox.com/ubuntu $(lsb_release -s -c) main" | sudo tee /etc/apt/sources.list.d/dropbox.list
	echo "deb [arch=i386,amd64] http://linux.dropbox.com/ubuntu bionic main" | sudo tee /etc/apt/sources.list.d/dropbox.list
	sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 1C61A2656FB57B7E4DE0F4C1FC918B335044912E

	# Spotify
	curl -sS https://download.spotify.com/debian/pubkey.gpg | sudo apt-key add - 
	echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list

	# Kubectl
	curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
	echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list

	# add the yubico ppa gpg key
	#sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 3653E21064B19D134466702E43D5C49532CBA1A9

	# add the tlp apt-repo gpg key
	#sudo apt-key adv --keyserver pool.sks-keyservers.net --recv-keys CD4E8809

	#add keypass repository
	sudo apt-add-repository -y ppa:jtaylor/keepass

	# add veracrypt repo
	sudo add-apt-repository -y ppa:unit193/encryption

	# add signal app repo
	echo "deb [arch=amd64] https://updates.signal.org/desktop/apt xenial main" | sudo tee -a /etc/apt/sources.list.d/signal-xenial.list
	curl -s https://updates.signal.org/desktop/apt/keys.asc | sudo apt-key add -

	# add k6 repo
	sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 379CE192D401AB61
	echo "deb https://dl.bintray.com/loadimpact/deb stable main" | sudo tee -a /etc/apt/sources.list

	# add github cli
	sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-key C99B11DEB97541F0
	sudo apt-add-repository https://cli.github.com/packages

	# add terraform cli
	curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
	sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"


}

base_min() {
	sudo apt-get update
	sudo apt-get -y upgrade

	sudo apt-get install -y \
		adduser \
		automake \
		bash-completion \
		bc \
		bzip2 \
		ca-certificates \
		coreutils \
		curl \
		dnsutils \
		file \
		findutils \
		gcc \
		git \
		gnupg \
		gnupg2 \
		gnupg-agent \
		grep \
		gzip \
		hostname \
		indent \
		iptables \
		jq \
		less \
		libc6-dev \
		locales \
		lsof \
		make \
		mount \
		net-tools \
		neovim \
		pinentry-curses \
		rxvt-unicode-256color \
		scdaemon \
		silversearcher-ag \
		ssh \
		strace \
		sudo \
		tar \
		tree \
		tzdata \
		unzip \
		xclip \
		xcompmgr \
		xz-utils \
		zip \
		tmux \
		spotify-client \
		kubectl \
		keepass2 \
		veracrypt \
		signal-desktop \
		k6 \
		azure-cli \
		gh \
		terraform \
		shellcheck \
		brave-browser \
		ripgrep \
		--no-install-recommends

	sudo apt-get autoremove
	sudo apt-get autoclean
	sudo apt-get clean

	install_scripts
	install_nvm
}

# installs base packages
# the utter bare minimal shit
base() {
	base_min;

	sudo apt-get update
	sudo apt-get -y upgrade

	sudo apt-get install -y \
		alsa-utils \
		apparmor \
		bridge-utils \
		cgroupfs-mount \
		chromium-browser \
		libltdl-dev \
		libseccomp-dev \
		network-manager \
		openvpn \
		s3cmd \
		code \
		nodejs \
		yarn \
		pinta \
		--no-install-recommends

	# install tlp with recommends
	sudo apt-get install -y tlp tlp-rdw

	sudo apt-get autoremove
	sudo apt-get autoclean
	sudo apt-get clean

	install_docker
}

# setup sudo for a user
# because fuck typing that shit all the time
# just have a decent password
# and lock your computer when you aren't using it
# if they have your password they can sudo anyways
# so its pointless
# i know what the fuck im doing ;)
setup_sudo() {
	# add user to sudoers
	adduser "$TARGET_USER" sudo

	# add user to systemd groups
	# then you wont need sudo to view logs and shit
	gpasswd -a "$TARGET_USER" systemd-journal
	gpasswd -a "$TARGET_USER" systemd-network

	# add go path to secure path
	{ \
		echo -e 'Defaults	secure_path="/usr/local/go/bin:/home/jessie/.go/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"'; \
		echo -e 'Defaults	env_keep += "ftp_proxy http_proxy https_proxy no_proxy GOPATH EDITOR"'; \
		echo -e "${TARGET_USER} ALL=(ALL) NOPASSWD:ALL"; \
		echo -e "${TARGET_USER} ALL=NOPASSWD: /sbin/ifconfig, /sbin/ifup, /sbin/ifdown, /sbin/ifquery"; \
	} >> /etc/sudoers

	# setup downloads folder as tmpfs
	# that way things are removed on reboot
	# i like things clean but you may not want this
	mkdir -p "/home/$TARGET_USER/Downloads"
	echo -e "\n# tmpfs for downloads\ntmpfs\t/home/${TARGET_USER}/Downloads\ttmpfs\tnodev,nosuid,size=2G\t0\t0" >> /etc/fstab
}

# installs docker and setup user
install_docker() {
	# create docker group
	getent group docker || sudo groupadd docker
	sudo usermod -aG docker "$TARGET_USER"

	# Include contributed completions
	sudo mkdir -p /etc/bash_completion.d
	sudo curl -sSL -o /etc/bash_completion.d/docker https://raw.githubusercontent.com/docker/docker-ce/master/components/cli/contrib/completion/bash/docker

	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
	echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

	sudo apt update
	sudo apt-get install -y docker-ce docker-ce-cli containerd.io

	# install docker-compose
	sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
	sudo chmod +x /usr/local/bin/docker-compose
}

# install/update golang from source
install_golang() {
	export GO_VERSION
	GO_VERSION=$(curl -sSL "https://golang.org/VERSION?m=text")

	export GO_SRC=/usr/local/go

	# if we are passing the version
	if [[ ! -z "$1" ]]; then
		GO_VERSION=$1
	fi

	echo "Installing go: ${GO_VERSION}"

	# purge old src
	if [[ -d "$GO_SRC" ]]; then
		sudo rm -rf "$GO_SRC"
	fi

	GO_VERSION=${GO_VERSION}

	# subshell
	(
	curl -sSL "https://storage.googleapis.com/golang/${GO_VERSION}.linux-amd64.tar.gz" | sudo tar -v -C /usr/local -xz
	local user="carl"
	# rebuild stdlib for faster builds
	#sudo chown -R "${user}" /usr/local/go/pkg
	#export PATH=$PATH:/usr/local/go/bin
	sudo chown -R carl /usr/local/go/pkg
	CGO_ENABLED=0 go install -a -installsuffix cgo std
	)

	# get commandline tools
	(
	set -x
	set +e
	go get -u github.com/golang/protobuf/protoc-gen-go
	go get github.com/golang/lint/golint
	go get golang.org/x/tools/cmd/cover
	go get golang.org/x/review/git-codereview
	go get golang.org/x/tools/cmd/goimports
	go get golang.org/x/tools/cmd/gorename
	go get golang.org/x/tools/cmd/guru
	go get github.com/Unknwon/bra

	GO111MODULE=on go get -u github.com/jsonnet-bundler/jsonnet-bundler/cmd/jb
	GO111MODULE=on go get github.com/grafana/tanka/cmd/tk

	go get github.com/github/hub
	go get github.com/jessfraz/pepper
	go get github.com/jessfraz/udict
	go get github.com/jessfraz/weather
	go get github.com/crosbymichael/gistit
	go get github.com/davecheney/httpstat
	go get github.com/google/gops
	go get github.com/nsf/gocode
	go get github.com/rogpeppe/godef

	go get github.com/uudashr/gopkgs/cmd/gopkgs
	go get github.com/ramya-rao-a/go-outline
	go get github.com/acroca/go-symbols
	go get github.com/fatih/gomodifytags
	go get github.com/haya14busa/goplay/cmd/goplay
	go get github.com/josharian/impl
	go get golang.org/x/tools/cmd/godoc
	go get github.com/cweill/gotests/...
	go get github.com/derekparker/delve/cmd/dlv
	)
}

setup_golang_devenv() {
	(
	set -x
	set +e

	myprojs=( grafana/grafana grafana/grafana-plugin-sdk-go grafana/hosted-grafana grafana/grafonnet-lib )
	for project in "${myprojs[@]}"; do
		owner=$(dirname "$project")
		repo=$(basename "$project")
		mkdir -p "${GOPATH}/src/github.com/${owner}"

		if [[ ! -d "${GOPATH}/src/github.com/${project}" ]]; then
			(
			# clone the repo
			cd "${GOPATH}/src/github.com/${owner}"
			git clone "git@github.com:${project}.git"
			cd "${GOPATH}/src/github.com/${project}"
			git remote add fork "git@github.com:bergquist/${repo}.git"
			)
		else
			echo "found ${project} already in gopath"
		fi
	done

	others=( bergquist/bergquist.github.com prometheus/prometheus prometheus/client_golang prometheus/client_model prometheus/common )
	for project in "${others[@]}"; do
		owner=$(dirname "$project")
		repo=$(basename "$project")
		mkdir -p "${GOPATH}/src/github.com/${owner}"

		if [[ ! -d "${GOPATH}/src/github.com/${project}" ]]; then
			(
			# clone the repo
			cd "${GOPATH}/src/github.com/${owner}"
			git clone "git@github.com:${project}.git"
			cd "${GOPATH}/src/github.com/${project}"
			)
		else
			echo "found ${project} already in gopath"
		fi
	done
	)
}

# install graphics drivers
install_graphics() {
	local system=$1

	if [[ -z "$system" ]]; then
		echo "You need to specify whether it's intel, geforce or optimus"
		exit 1
	fi

	local pkgs=( xorg xserver-xorg )

	case $system in
		"intel")
			pkgs+=( xserver-xorg-video-intel )
			;;
		"geforce")
			pkgs+=( nvidia-driver )
			;;
		"optimus")
			pkgs+=( nvidia-kernel-dkms bumblebee-nvidia primus )
			;;
		*)
			echo "You need to specify whether it's intel, geforce or optimus"
			exit 1
			;;
	esac

	apt-get install -y "${pkgs[@]}" --no-install-recommends
}

# install custom scripts/binaries
install_scripts() {
	# install speedtest
	sudo wget https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py -O /usr/local/bin/speedtest
	sudo chmod +x /usr/local/bin/speedtest

	# install icdiff
	sudo wget https://raw.githubusercontent.com/jeffkaufman/icdiff/master/icdiff -O /usr/local/bin/icdiff
	sudo wget https://raw.githubusercontent.com/jeffkaufman/icdiff/master/git-icdiff -O /usr/local/bin/git-icdiff
	sudo chmod +x /usr/local/bin/icdiff
	sudo chmod +x /usr/local/bin/git-icdiff

	# install lolcat
	sudo wget https://raw.githubusercontent.com/tehmaze/lolcat/master/lolcat -O /usr/local/bin/lolcat
	sudo chmod +x /usr/local/bin/lolcat

	curl -sSL "https://github.com/derailed/k9s/releases/download/v0.24.10/k9s_v0.24.10_Linux_x86_64.tar.gz" | sudo tar -v -C /usr/local -xz
}

# install syncthing
install_syncthing() {
	# download syncthing binary
	if [[ ! -f /usr/local/bin/syncthing ]]; then
		curl -sSL https://misc.j3ss.co/binaries/syncthing > /usr/local/bin/syncthing
		chmod +x /usr/local/bin/syncthing
	fi

	syncthing -upgrade

	curl -sSL https://raw.githubusercontent.com/jessfraz/dotfiles/master/etc/systemd/system/syncthing@.service > /etc/systemd/system/syncthing@.service

	systemctl daemon-reload
	systemctl enable "syncthing@${TARGET_USER}"
}

# install wifi drivers
install_wifi() {
	local system=$1

	if [[ -z "$system" ]]; then
		echo "You need to specify whether it's broadcom or intel"
		exit 1
	fi

	if [[ $system == "broadcom" ]]; then
		local pkg="broadcom-sta-dkms"

		apt-get install -y "$pkg" --no-install-recommends
	else
		update-iwlwifi
	fi
}

# install stuff for i3 window manager
install_wmapps() {
	local pkgs=( feh i3 i3lock i3status scrot slim suckless-tools )

	apt-get install -y "${pkgs[@]}" --no-install-recommends

	# update clickpad settings
	mkdir -p /etc/X11/xorg.conf.d/
	curl -sSL https://raw.githubusercontent.com/jessfraz/dotfiles/master/etc/X11/xorg.conf.d/50-synaptics-clickpad.conf > /etc/X11/xorg.conf.d/50-synaptics-clickpad.conf

	# add xorg conf
	curl -sSL https://raw.githubusercontent.com/jessfraz/dotfiles/master/etc/X11/xorg.conf > /etc/X11/xorg.conf

	# get correct sound cards on boot
	curl -sSL https://raw.githubusercontent.com/jessfraz/dotfiles/master/etc/modprobe.d/intel.conf > /etc/modprobe.d/intel.conf

	# pretty fonts
	curl -sSL https://raw.githubusercontent.com/jessfraz/dotfiles/master/etc/fonts/local.conf > /etc/fonts/local.conf

	echo "Fonts file setup successfully now run:"
	echo "	dpkg-reconfigure fontconfig-config"
	echo "with settings: "
	echo "	Autohinter, Automatic, No."
	echo "Run: "
	echo "	dpkg-reconfigure fontconfig"
}

get_dotfiles() {
	# create subshell
	(
	cd "$HOME"

	# install dotfiles from repo
	git clone git@github.com:bergquist/dotfiles.git "${HOME}/.dotfiles"
	cd "${HOME}/.dotfiles"

	# installs all the things
	make

	# enable dbus for the user session
	# systemctl --user enable dbus.socket

	#sudo systemctl enable "i3lock@${TARGET_USER}"
	#sudo systemctl enable suspend-sedation.service

	cd "$HOME"
	mkdir -p ~/Pictures
	)

	install_vim;
}

install_vim() {
	# create subshell
	(
	cd "$HOME"

	# install .vim files
	git clone --recursive https://github.com/bergquist/.vim "${HOME}/.vim"
	ln -snf "${HOME}/.vim/vimrc" "${HOME}/.vimrc"
	sudo ln -snf "${HOME}/.vim" /root/.vim
	sudo ln -snf "${HOME}/.vimrc" /root/.vimrc

	# alias vim dotfiles to neovim
	mkdir -p "${XDG_CONFIG_HOME:=$HOME/.config}"
	ln -snf "${HOME}/.vim" "${XDG_CONFIG_HOME}/nvim"
	ln -snf "${HOME}/.vimrc" "${XDG_CONFIG_HOME}/nvim/init.vim"
	# do the same for root
	sudo mkdir -p /root/.config
	sudo ln -snf "${HOME}/.vim" /root/.config/nvim
	sudo ln -snf "${HOME}/.vimrc" /root/.config/nvim/init.vim

	# update alternatives to neovim
	sudo update-alternatives --install /usr/bin/vi vi "$(which nvim)" 60
	sudo update-alternatives --config vi
	sudo update-alternatives --install /usr/bin/vim vim "$(which nvim)" 60
	sudo update-alternatives --config vim
	sudo update-alternatives --install /usr/bin/editor editor "$(which nvim)" 60
	sudo update-alternatives --config editor

	# install things needed for deoplete for vim
	sudo apt-get update

	sudo apt-get install -y \
		python3-pip \
		python3-setuptools \
		--no-install-recommends

	pip3 install -U \
		setuptools \
		wheel \
		neovim
	)
}

install_virtualbox() {
	# check if we need to install libvpx1
	PKG_OK=$(dpkg-query -W --showformat='${Status}\n' libvpx1 | grep "install ok installed")
	echo "Checking for libvpx1: $PKG_OK"
	if [ "" == "$PKG_OK" ]; then
		echo "No libvpx1. Installing libvpx1."
		jessie_sources=/etc/apt/sources.list.d/jessie.list
		echo "deb http://httpredir.debian.org/debian jessie main contrib non-free" > "$jessie_sources"

		apt-get update
		apt-get install -y -t jessie libvpx1 \
			--no-install-recommends

		# cleanup the file that we used to install things from jessie
		rm "$jessie_sources"
	fi

	echo "deb http://download.virtualbox.org/virtualbox/debian vivid contrib" >> /etc/apt/sources.list.d/virtualbox.list

	curl -sSL https://www.virtualbox.org/download/oracle_vbox.asc | apt-key add -

	apt-get update
	apt-get install -y \
		virtualbox-5.0
	--no-install-recommends
}

install_vagrant() {
	VAGRANT_VERSION=1.8.1

	# if we are passing the version
	if [[ ! -z "$1" ]]; then
		export VAGRANT_VERSION=$1
	fi

	# check if we need to install virtualbox
	PKG_OK=$(dpkg-query -W --showformat='${Status}\n' virtualbox | grep "install ok installed")
	echo "Checking for virtualbox: $PKG_OK"
	if [ "" == "$PKG_OK" ]; then
		echo "No virtualbox. Installing virtualbox."
		install_virtualbox
	fi

	tmpdir=$(mktemp -d)
	(
	cd "$tmpdir"
	curl -sSL -o vagrant.deb "https://releases.hashicorp.com/vagrant/${VAGRANT_VERSION}/vagrant_${VAGRANT_VERSION}_x86_64.deb"
	dpkg -i vagrant.deb
	)

	rm -rf "$tmpdir"

	# install plugins
	vagrant plugin install vagrant-vbguest
}

install_protobuf() {
	# Make sure you grab the latest version
	(
	mkdir -p ~/.tmp-pbuf
	cd ~/.tmp-pbuf

	VERSION=3.4.0

	curl -OL "https://github.com/google/protobuf/releases/download/v$VERSION/protoc-$VERSION-linux-x86_64.zip"

	# Unzip
	unzip "protoc-$VERSION-linux-x86_64.zip" -d protoc3

	# Move protoc to /usr/local/bin/
	sudo rm -rf /usr/local/bin/protoc
	sudo mv protoc3/bin/* /usr/local/bin/

	# Move protoc3/include to /usr/local/include/
	sudo rm -rf /usr/local/include/google
	sudo mv protoc3/include/* /usr/local/include/

	# Optional: change owner
	sudo chown $USER /usr/local/bin/protoc
	sudo chown -R $USER /usr/local/include/google

	rm -rf ~/.tmp-pbuf
	)
}

install_spotify() {
	curl -sS https://download.spotify.com/debian/pubkey.gpg | sudo apt-key add - 
	echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list

	sudo apt-get update

	sudo apt-get install spotify-client
}

install_jsonnet() {
	mkdir -p ~/go/src/github.com/google
	cd ~/go/src/github.com/google

	if cd jsonnet; then git pull; else git clone https://github.com/google/jsonnet; cd jsonnet; fi

	make

	sudo cp ./jsonnet /usr/local/bin
	sudo cp ./jsonnetfmt /usr/local/bin
}

install_dropbox() {
	echo "deb [arch=i386,amd64] http://linux.dropbox.com/ubuntu xenial main" | sudo tee /etc/apt/sources.list.d/dropbox.list

	sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 1C61A2656FB57B7E4DE0F4C1FC918B335044912E

	sudo apt update
	sudo apt install python-gpg dropbox
}

install_gcloud() {
	export CLOUD_SDK_REPO="cloud-sdk-$(lsb_release -c -s)"
	echo "deb http://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
	curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -

	sudo apt-get update 
	sudo apt-get install google-cloud-sdk google-cloud-sdk-app-engine-go
}

install_nvm() {
	curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash
}

usage() {
	echo -e "install.sh\n\tThis script installs my basic setup for a debian laptop\n"
	echo "Usage:"
	echo "  base                                - setup sources & install base pkgs"
	echo "  basemin                             - setup sources & install base min pkgs"
	echo "  wifi {broadcom, intel}              - install wifi drivers"
	echo "  graphics {intel, geforce, optimus}  - install graphics drivers"
	echo "  wm                                  - install window manager/desktop pkgs"
	echo "  dotfiles                            - get dotfiles"
	echo "  vim                                 - install vim specific dotfiles"
	echo "  golang                              - install golang and packages"
	echo "  golang_devenv                       - install my golang dev env"
	echo "  scripts                             - install scripts"
	echo "  syncthing                           - install syncthing"
	echo "  vagrant                             - install vagrant and virtualbox"
	echo "  vscode                              - install vscode"
	echo "  protobuf                            - install protobuf"
	echo "  spotify                             - install spotify"
	echo "  jsonnet                             - install jsonnet"
	echo "  dropbox                             - install dropbox"
	echo "  gcloud                              - install gcloud"
	echo "  nvm                                 - install nvm"
}

main() {
	local cmd=$1

	if [[ -z "$cmd" ]]; then
		usage
		exit 1
	fi

	if [[ $cmd == "base" ]]; then
		#check_is_sudo
		get_user

		setup_sources

		base
	elif [[ $cmd == "basemin" ]]; then
		#check_is_sudo
		get_user

		setup_sources_min

		base_min
	elif [[ $cmd == "wifi" ]]; then
		install_wifi "$2"
	elif [[ $cmd == "graphics" ]]; then
		check_is_sudo

		install_graphics "$2"
	elif [[ $cmd == "wm" ]]; then
		check_is_sudo

		install_wmapps
	elif [[ $cmd == "dotfiles" ]]; then
		get_user
		get_dotfiles
	elif [[ $cmd == "vim" ]]; then
		install_vim
	elif [[ $cmd == "spotify" ]]; then
		install_spotify
	elif [[ $cmd == "golang" ]]; then
		install_golang "$2"
    elif [[ $cmd == "golang_devenv" ]]; then
        setup_golang_devenv
	elif [[ $cmd == "scripts" ]]; then
		install_scripts
	elif [[ $cmd == "syncthing" ]]; then
		get_user
		install_syncthing
	elif [[ $cmd == "vagrant" ]]; then
		install_vagrant "$2"
	elif [[ $cmd == "protobuf" ]]; then
		install_protobuf
	elif [[ $cmd == "jsonnet" ]]; then
		install_jsonnet
	elif [[ $cmd == "dropbox" ]]; then
		install_dropbox
	elif [[ $cmd == "docker" ]]; then
		get_user
		install_docker
	elif [[ $cmd == "dropbox" ]]; then
		install_dropbox
	elif [[ $cmd == "gcloud" ]]; then
		install_gcloud
	else
		usage
	fi
}

main "$@"
