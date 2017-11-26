chrome(){
	# add flags for proxy if passed
	local proxy=
	local map
	local args=$*
	if [[ "$1" == "tor" ]]; then
		relies_on torproxy

		map="MAP * ~NOTFOUND , EXCLUDE torproxy"
		proxy="socks5://torproxy:9050"
		args="https://check.torproject.org/api/ip ${*:2}"
	fi

	del_stopped chrome

	# one day remove /etc/hosts bind mount when effing
	# overlay support inotify, such bullshit
	docker run -d \
		--memory 3gb \
		-v /etc/localtime:/etc/localtime:ro \
		-v /tmp/.X11-unix:/tmp/.X11-unix \
		-e "DISPLAY=unix${DISPLAY}" \
		-v "${HOME}/Downloads:/root/Downloads" \
		-v "${HOME}/Pictures:/root/Pictures" \
		-v "${HOME}/Torrents:/root/Torrents" \
		-v "${HOME}/.chrome:/data" \
		-v /dev/shm:/dev/shm \
		-v /etc/hosts:/etc/hosts \
		--security-opt seccomp:/etc/docker/seccomp/chrome.json \
		--device /dev/snd \
		--device /dev/dri \
		--device /dev/video0 \
		--device /dev/usb \
		--device /dev/bus/usb \
		--group-add audio \
		--group-add video \
		--name chrome \
		${DOCKER_REPO_PREFIX}/chrome --user-data-dir=/data \
		--proxy-server="$proxy" \
		--host-resolver-rules="$map" "$args"

}