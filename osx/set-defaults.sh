#this is only for Mac
if [ $(uname -s) = "Darwin" ]
then
	# Disable press-and-hold for keys in favor of key repeat.
	defaults write -g ApplePressAndHoldEnabled -bool false

	# Always open everything in Finder's list view. This is important.
	defaults write com.apple.Finder FXPreferredViewStyle Nlsv

	# Show the ~/Library folder.
	chflags nohidden ~/Library

	# Set a really fast key repeat.
	defaults write NSGlobalDomain KeyRepeat -int 0

	# Run the screensaver if we're in the bottom-left hot corner.
	defaults write com.apple.dock wvous-bl-corner -int 5
	defaults write com.apple.dock wvous-bl-modifier -int 0

	# Only use UTF-8 in Terminal.app!
	defaults write com.apple.terminal StringEncodings -array 4

	# Disable the sound effects on boot. Great for those who go outside
	sudo nvram SystemAudioVolume=" "

	# Disable the “Are you sure you want to open this application?” dialog
	defaults write com.apple.LaunchServices LSQuarantine -bool false

	# Finder: allow quitting via ⌘ + Q; doing so will also hide desktop icons
	defaults write com.apple.finder QuitMenuItem -bool true

	# Disable the warning when changing a file extension
	defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

	# Avoid creating .DS_Store files on network volumes
	defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

	# Disable Dashboard
	defaults write com.apple.dashboard mcx-disabled -bool true

	# Don’t show Dashboard as a Space
	defaults write com.apple.dock dashboard-in-overlay -bool true

	# Don’t display the annoying prompt when quitting iTerm
	defaults write com.googlecode.iterm2 PromptOnQuit -bool false

	# Disable continuous spell checking
	defaults write com.apple.messageshelper.MessageController SOInputLineSettings -dict-add "continuousSpellCheckingEnabled" -bool false
fi
