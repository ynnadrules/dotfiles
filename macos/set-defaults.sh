#!/bin/sh
# Sets reasonable macOS defaults.
#
# Or, in other words, set shit how I like in macOS.
#
# The original idea (and a couple settings) were grabbed from:
#   https://github.com/mathiasbynens/dotfiles/blob/master/.osx
# More from:
#    https://gist.github.com/brandonb927/3195465
#
# Run ./set-defaults.sh and you'll be good to go.
if [ "$(uname -s)" != "Darwin" ]; then
	exit 0
fi

set +e

disable_agent() {
	mv "$1" "$1_DISABLED" >/dev/null 2>&1 ||
		sudo mv "$1" "$1_DISABLED" >/dev/null 2>&1
}

unload_agent() {
	launchctl unload -w "$1" >/dev/null 2>&1
}

test -z "$TRAVIS_JOB_ID" && sudo -v

echo ""
echo "› System:"

echo "  › Set computer name"
name="expanse"
sudo scutil --set ComputerName "${name}"
sudo scutil --set HostName "${name}"
sudo scutil --set LocalHostName "${name}"
sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string "${name}"

echo "  › Disable press-and-hold for keys in favor of key repeat"
defaults write -g ApplePressAndHoldEnabled -bool false

echo "  › Set a really fast key repeat"
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15

echo "  › Enable text replacement almost everywhere"
defaults write -g WebAutomaticTextReplacementEnabled -bool true

echo "  › Turn off keyboard illumination when computer is not used for 5 minutes"
defaults write com.apple.BezelServices kDimTime -int 300

echo "  › Show scrollbars when scrolling"
defaults write NSGlobalDomain AppleShowScrollBars -string "WhenScrolling"
# Possible values: `WhenScrolling`, `Automatic` and `Always`

echo "  › Increase the window resize speed for Cocoa applications"
defaults write NSGlobalDomain NSWindowResizeTime -float 0.001

echo "  › Expand save panel by default"
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

echo "  › Expand print panel by default"
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

echo "  › Disable smart quotes and smart dashes as they're annoying when typing code"
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

echo "  › Disable auto-correct"
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

echo "  › Disable automatic capitalization as it’s annoying when typing code"
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false

echo "  › Disable automatic period substitution as it’s annoying when typing code"
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false

echo "  › Automatically quit printer app once the print jobs complete"
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

echo "  › Set up trackpad & mouse speed to a reasonable number"
defaults write -g com.apple.trackpad.scaling 2
defaults write -g com.apple.mouse.scaling 2.5

echo "  › Avoid the creation of .DS_Store files on network volumes"
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

echo "  › Set Help Viewer windows to non-floating mode"
defaults write com.apple.helpviewer DevMode -bool true

echo "  › Disable the 'Are you sure you want to open this application?' dialog"
defaults write com.apple.LaunchServices LSQuarantine -bool false

echo "  › Disable automatic termination of inactive apps"
defaults write NSGlobalDomain NSDisableAutomaticTermination -bool true

echo "  › Set Help Viewer windows to non-floating mode"
defaults write com.apple.helpviewer DevMode -bool true

echo "  › Reveal IP address, hostname, OS version, etc. when clicking the clock in the login window"
sudo defaults write /Library/Preferences/com.apple.loginwindow AdminHostInfo HostName

echo "  › Restart automatically if the computer freezes"
sudo systemsetup -setrestartfreeze on

echo "  › Set dark interface style"
defaults write NSGlobalDomain AppleInterfaceStyle -string "Dark"

echo "  › Set graphite appearance"
defaults write NSGlobalDomain AppleAquaColorVariant -int 6

echo "  › Set graphite highlight color"
defaults write NSGlobalDomain AppleHighlightColor -string "0.847059 0.847059 0.862745"

echo "  › Show battery percent"
defaults write com.apple.menuextra.battery ShowPercent -bool true

if [ -n "$TRAVIS_JOB_ID" ]; then
  echo "  › Disable the sound effects on boot"
  sudo nvram SystemAudioVolume=" "

	echo "  › Speed up wake from sleep to 24 hours from an hour"
	# http://www.cultofmac.com/221392/quick-hack-speeds-up-retina-macbooks-wake-from-sleep-os-x-tips/
	sudo pmset -a standbydelay 86400
fi

echo "  › Removing duplicates in the 'Open With' menu"
/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister \
	-kill -r -domain local -domain system -domain user

#############################
echo ""
echo "› Trackpad, mouse, keyboard, bluetooth accessories, and input:"

echo "  › Increase sound quality for Bluetooth headphones/headsets"
defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" -int 40

echo "  › Enable full keyboard access for all controls"
echo "  › (e.g. enable Tab in modal dialogs)"
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

echo "  › Use scroll gesture with the Ctrl (^) modifier key to zoom"
defaults write com.apple.universalaccess closeViewScrollWheelToggle -bool true
defaults write com.apple.universalaccess HIDScrollZoomModifierMask -int 262144

echo "  › Follow the keyboard focus while zoomed in"
defaults write com.apple.universalaccess closeViewZoomFollowsFocus -bool true

echo "  › Enable 4-finger double tap to go back to recent space"
defaults write com.apple.dock double-tap-jump-back -bool TRUE

echo "  › Set language and text formats"
# Note: if you’re in the US, replace `EUR` with `USD`, `Centimeters` with
# `Inches`, `en_GB` with `en_US`, and `true` with `false`.
defaults write NSGlobalDomain AppleLanguages -array "en"
defaults write NSGlobalDomain AppleLocale -string "en_US@currency=USD"
defaults write NSGlobalDomain AppleMeasurementUnits -string "Inches"
defaults write NSGlobalDomain AppleMetricUnits -bool true

echo "  › Set the timezone; see `sudo systemsetup -listtimezones` for other values"
sudo systemsetup -settimezone "America/Chicago" > /dev/null

#############################
echo ""
echo "› Screen:"

echo "  › Require password immediately after sleep or screen saver begins"
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

echo "  › Save screenshots to the desktop"
defaults write com.apple.screencapture location -string "${HOME}/Desktop"

echo "  › Save screenshots in PNG format (other options: BMP, GIF, JPG, PDF, TIFF)"
defaults write com.apple.screencapture type -string "png"

# echo "  › Disable shadow in screenshots"
# defaults write com.apple.screencapture disable-shadow -bool true

echo "  › Enable subpixel font rendering on non-Apple LCDs"
# Reference: https://github.com/kevinSuttle/macOS-Defaults/issues/17#issuecomment-266633501
defaults write NSGlobalDomain AppleFontSmoothing -int 1

echo "  › Enable HiDPI display modes (requires restart)"
sudo defaults write /Library/Preferences/com.apple.windowserver DisplayResolutionEnabled -bool true

#############################
echo ""
echo "› Finder:"
echo "  › Always open everything in Finder's list view"
# Four-letter codes for the other view modes: `icnv` (icon/grid view), `clmv` (column view), `Flwv` (cover flow view), `Nlsv` (list view)
defaults write com.apple.Finder FXPreferredViewStyle -string "clmv"

echo "  › Set the Finder prefs for showing a few different volumes on the Desktop"
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true

echo "  › Expand save panel by default"
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true

echo "  › Set sidebar icon size to small"
defaults write NSGlobalDomain NSTableViewDefaultSizeMode -int 1

echo "  › Show status bar"
defaults write com.apple.finder ShowStatusBar -bool true

echo "  › Show path bar"
defaults write com.apple.finder ShowPathbar -bool true

# echo "  › Disable the warning before emptying the Trash"
# defaults write com.apple.finder WarnOnEmptyTrash -bool false

# echo "  › Save to disk by default, instead of iCloud"
# defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

echo "  › Display full POSIX path as Finder window title"
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

echo "  › Disable the warning when changing a file extension"
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

echo "  › Use AirDrop over every interface"
defaults write com.apple.NetworkBrowser BrowseAllInterfaces 1

echo "  › Show the ~/Library folder"
chflags nohidden ~/Library

echo "  › Show the /Volumes folder"
sudo chflags nohidden /Volumes

echo "  › Expand the following File Info panes:"
# “General”, “Open with”, and “Sharing & Permissions”
defaults write com.apple.finder FXInfoPanesExpanded -dict \
	General -bool true \
	OpenWith -bool true \
	Privileges -bool true

#############################

#############################
echo ""
echo "› Dock, Dashboard, and hot corners:"

echo "  › Enable highlight hover effect for the grid view of a stack (Dock)"
defaults write com.apple.dock mouse-over-hilite-stack -bool true

echo "  › Setting the icon size of Dock items to 36 pixels for optimal size/screen-realestate"
defaults write com.apple.dock tilesize -int 36

echo "  › Change minimize/maximize window effect"
defaults write com.apple.dock mineffect -string "scale"

echo "  › Minimize windows into their application’s icon"
defaults write com.apple.dock minimize-to-application -bool true

echo "  › Enable spring loading for all Dock items"
defaults write com.apple.dock enable-spring-load-actions-on-all-items -bool true

echo "  › Show indicator lights for open applications in the Dock"
defaults write com.apple.dock show-process-indicators -bool true

echo "  › Speeding up Mission Control animations and grouping windows by application"
defaults write com.apple.dock expose-animation-duration -float 0.1
defaults write com.apple.dock "expose-group-by-app" -bool true

echo "  › Remove the auto-hiding Dock delay"
defaults write com.apple.dock autohide-delay -float 0

# echo "  › Remove the animation when hiding/showing the Dock"
# defaults write com.apple.dock autohide-time-modifier -float 0

echo "  › Automatically hide and show the Dock"
defaults write com.apple.dock autohide -bool true

# echo "  › Don't animate opening applications from the Dock"
# defaults write com.apple.dock launchanim -bool false

echo "  › Wipe all (default) app icons from the Dock"
# This is only really useful when setting up a new Mac, or if you don’t use
# the Dock to launch apps.
defaults write com.apple.dock persistent-apps -array

echo "  › Show only open applications in the Dock"
defaults write com.apple.dock static-only -bool true

echo "  › Disable Dashboard"
defaults write com.apple.dashboard mcx-disabled -bool true

echo "  › Don't automatically rearrange Spaces based on most recent use"
defaults write com.apple.dock mru-spaces -bool false

echo "  › Don’t show Dashboard as a Space"
defaults write com.apple.dock dashboard-in-overlay -bool true

echo "  › Make Dock icons of hidden applications translucent"
defaults write com.apple.dock showhidden -bool true

echo "  › Reset Launchpad, but keep the desktop wallpaper intact"
find "${HOME}/Library/Application Support/Dock" -name "*-*.db" -maxdepth 1 -delete

# Add a spacer to the left side of the Dock (where the applications are)
#defaults write com.apple.dock persistent-apps -array-add '{tile-data={}; tile-type="spacer-tile";}'
# Add a spacer to the right side of the Dock (where the Trash is)
#defaults write com.apple.dock persistent-others -array-add '{tile-data={}; tile-type="spacer-tile";}'

echo "  › Hot corners"
# Possible values:
#  0: no-op
#  2: Mission Control
#  3: Show application windows
#  4: Desktop
#  5: Start screen saver
#  6: Disable screen saver
#  7: Dashboard
# 10: Put display to sleep
# 11: Launchpad
# 12: Notification Center
# Top left screen corner → Mission Control
defaults write com.apple.dock wvous-tl-corner -int 2
defaults write com.apple.dock wvous-tl-modifier -int 0
# Top right screen corner → Put Display to sleep
defaults write com.apple.dock wvous-tr-corner -int 10
defaults write com.apple.dock wvous-tr-modifier -int 0
# Bottom left screen corner → Desktop
defaults write com.apple.dock wvous-bl-corner -int 4
defaults write com.apple.dock wvous-bl-modifier -int 0

#############################
echo ""
echo "› Photos:"
echo "  › Disable it from starting everytime a device is plugged in"
defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true

#############################

echo ""
echo "› Browsers:"
echo "  › Set up Safari for development"
defaults write com.apple.Safari IncludeInternalDebugMenu -bool true
defaults write com.apple.Safari IncludeDevelopMenu -bool true
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
defaults write com.apple.Safari "com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled" -bool true
defaults write NSGlobalDomain WebKitDeveloperExtras -bool true

echo "  › Privacy: don’t send search queries to Apple"
defaults write com.apple.Safari UniversalSearchEnabled -bool false
defaults write com.apple.Safari SuppressSearchSuggestions -bool true

echo "  › Press Tab to highlight each item on a web page"
defaults write com.apple.Safari WebKitTabToLinksPreferenceKey -bool true
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2TabsToLinks -bool true

echo "  › Show the full URL in the address bar (note: this still hides the scheme)"
defaults write com.apple.Safari ShowFullURLInSmartSearchField -bool true

echo "  › Set Safari’s home page to `about:blank` for faster loading"
defaults write com.apple.Safari HomePage -string "about:blank"

echo "  › Prevent Safari from opening ‘safe’ files automatically after downloading"
defaults write com.apple.Safari AutoOpenSafeDownloads -bool false

echo "  › Hide Safari’s bookmarks bar by default"
defaults write com.apple.Safari ShowFavoritesBar -bool false

echo "  › Hide Safari’s sidebar in Top Sites"
defaults write com.apple.Safari ShowSidebarInTopSites -bool false

echo "  › Make Safari’s search banners default to Contains instead of Starts With"
defaults write com.apple.Safari FindOnPageMatchesWordStartsOnly -bool false

echo "  › Enable continuous spellchecking"
defaults write com.apple.Safari WebContinuousSpellCheckingEnabled -bool true

echo "  › Disable auto-correct"
defaults write com.apple.Safari WebAutomaticSpellingCorrectionEnabled -bool false

echo "  › Disable AutoFill"
defaults write com.apple.Safari AutoFillFromAddressBook -bool false
defaults write com.apple.Safari AutoFillPasswords -bool false
defaults write com.apple.Safari AutoFillCreditCardData -bool false
defaults write com.apple.Safari AutoFillMiscellaneousForms -bool false

echo "  › Warn about fraudulent websites"
defaults write com.apple.Safari WarnAboutFraudulentWebsites -bool true

echo "  › Disable plug-ins"
defaults write com.apple.Safari WebKitPluginsEnabled -bool false
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2PluginsEnabled -bool false

echo "  › Disable Java"
defaults write com.apple.Safari WebKitJavaEnabled -bool false
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaEnabled -bool false

echo "  › Block pop-up windows"
defaults write com.apple.Safari WebKitJavaScriptCanOpenWindowsAutomatically -bool false
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaScriptCanOpenWindowsAutomatically -bool false

echo "  › Disable auto-playing video"
defaults write com.apple.Safari WebKitMediaPlaybackAllowsInline -bool false
defaults write com.apple.SafariTechnologyPreview WebKitMediaPlaybackAllowsInline -bool false
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2AllowsInlineMediaPlayback -bool false
defaults write com.apple.SafariTechnologyPreview com.apple.Safari.ContentPageGroupIdentifier.WebKit2AllowsInlineMediaPlayback -bool false

echo "  › Enable “Do Not Track”"
defaults write com.apple.Safari SendDoNotTrackHTTPHeader -bool true

echo "  › Update extensions automatically"
defaults write com.apple.Safari InstallExtensionUpdatesAutomatically -bool true

echo "  › Remove useless icons from Safari’s bookmarks bar"
defaults write com.apple.Safari ProxiesInBookmarksBar "()"

echo "  › Disable Safari’s thumbnail cache for History and Top Sites"
defaults write com.apple.Safari DebugSnapshotsUpdatePolicy -int 2

echo "  › Ensure backswipe in Chrome"
defaults write com.google.Chrome AppleEnableSwipeNavigateWithScrolls -bool true

#############################

echo ""
echo "› Transmission:"
echo "  › Use ~/Downloads/Incomplete to store incomplete downloads"
defaults write org.m0k.transmission UseIncompleteDownloadFolder -bool true
defaults write org.m0k.transmission IncompleteDownloadFolder -string "$HOME/Downloads/Incomplete"

echo "  › Don't prompt for confirmation before downloading"
defaults write org.m0k.transmission DownloadAsk -bool false

echo "  › Trash original torrent files"
defaults write org.m0k.transmission DeleteOriginalTorrent -bool true

echo "  › Hide the donate message"
defaults write org.m0k.transmission WarningDonate -bool false

echo "  › Hide the legal disclaimer"
defaults write org.m0k.transmission WarningLegal -bool false

echo "  › Auto-add .torrent files in ~/Downloads"
defaults write org.m0k.transmission AutoImportDirectory -string "$HOME/Downloads"

echo "  › Auto-resize the window to fit transfers"
defaults write org.m0k.transmission AutoSize -bool true

echo "  › Auto update to betas"
defaults write org.m0k.transmission AutoUpdateBeta -bool true

echo "  › Set up the best block list"
defaults write org.m0k.transmission EncryptionRequire -bool true
defaults write org.m0k.transmission BlocklistAutoUpdate -bool true
defaults write org.m0k.transmission BlocklistNew -bool true
defaults write org.m0k.transmission BlocklistURL -string "http://john.bitsurge.net/public/biglist.p2p.gz"

echo "  › Randomize port on launch"
defaults write org.m0k.transmission RandomPort -bool true

#############################

echo ""
echo "› Mail:"
echo "  › Add the keyboard shortcut CMD + Enter to send an email"
defaults write com.apple.mail NSUserKeyEquivalents -dict-add "Send" "@\U21a9"
echo "  › Add the keyboard shortcut CMD + Shift + E to archive an email"
# shellcheck disable=SC2016
defaults write com.apple.mail NSUserKeyEquivalents -dict-add "Archive" '@$e'

echo "  › Disable smart quotes as it's annoying for messages that contain code"
defaults write com.apple.messageshelper.MessageController SOInputLineSettings -dict-add "automaticQuoteSubstitutionEnabled" -bool false

echo "  › Set email addresses to copy as 'foo@example.com' instead of 'Foo Bar <foo@example.com>'"
defaults write com.apple.mail AddressesIncludeNameOnPasteboard -bool false

echo "  › Display emails in threaded mode, sorted by date (oldest at the top)"
defaults write com.apple.mail DraftsViewerAttributes -dict-add "DisplayInThreadedMode" -string "yes"
defaults write com.apple.mail DraftsViewerAttributes -dict-add "SortedDescending" -string "yes"
defaults write com.apple.mail DraftsViewerAttributes -dict-add "SortOrder" -string "received-date"

echo "  › Disable inline attachments (just show the icons)"
defaults write com.apple.mail DisableInlineAttachmentViewing -bool true

echo "  › Disable automatic spell checking"
defaults write com.apple.mail SpellCheckingBehavior -string "NoSpellCheckingEnabled"

echo "  ›  Disable send and reply animations in Mail.app"
defaults write com.apple.mail DisableReplyAnimations -bool true
defaults write com.apple.mail DisableSendAnimations -bool true

#############################

echo ""
echo "› Time Machine:"
echo "  › Prevent Time Machine from prompting to use new hard drives as backup volume"
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

###############################################################################
# SSD-specific tweaks                                                         #
###############################################################################
if [ -n "$TRAVIS_JOB_ID" ] && diskutil info disk0 | grep SSD >/dev/null 2>&1; then
	echo "  › Disable local backups"
	# https://classicyuppie.com/what-crap-is-this-os-xs-mobilebackups/
	sudo tmutil disablelocal

	echo "  › Disable hibernation (speeds up entering sleep mode)"
	sudo pmset -a hibernatemode 0

	echo "  › Remove the sleep image file to save disk space"
	sudo rm /private/var/vm/sleepimage
	echo "  › Create a zero-byte file instead..."
	sudo touch /private/var/vm/sleepimage
	echo "  › ...and make sure it can’t be rewritten"
	sudo chflags uchg /private/var/vm/sleepimage

	echo "  ›  Disable the sudden motion sensor as it’s not useful for SSDs"
	sudo pmset -a sms 0
fi

#############################

echo ""
echo "› Spotlight:"
# Hide Spotlight tray-icon (and subsequent helper)
#sudo chmod 600 /System/Library/CoreServices/Search.bundle/Contents/MacOS/Search
echo "  › Disable Spotlight indexing for any volume that gets mounted and has not yet been indexed before."
# Use `sudo mdutil -i off "/Volumes/foo"` to stop indexing any volume.
sudo defaults write /.Spotlight-V100/VolumeConfiguration Exclusions -array "/Volumes"
echo "  › Change indexing order and disable some search results"
# Yosemite-specific search results (remove them if you are using macOS 10.9 or older):
# 	MENU_DEFINITION
# 	MENU_CONVERSION
# 	MENU_EXPRESSION
# 	MENU_SPOTLIGHT_SUGGESTIONS (send search queries to Apple)
# 	MENU_WEBSEARCH             (send search queries to Apple)
# 	MENU_OTHER
defaults write com.apple.spotlight orderedItems -array \
	'{"enabled" = 1;"name" = "APPLICATIONS";}' \
	'{"enabled" = 1;"name" = "SYSTEM_PREFS";}' \
	'{"enabled" = 1;"name" = "DIRECTORIES";}' \
	'{"enabled" = 1;"name" = "PDF";}' \
	'{"enabled" = 1;"name" = "FONTS";}' \
	'{"enabled" = 0;"name" = "DOCUMENTS";}' \
	'{"enabled" = 0;"name" = "MESSAGES";}' \
	'{"enabled" = 0;"name" = "CONTACT";}' \
	'{"enabled" = 0;"name" = "EVENT_TODO";}' \
	'{"enabled" = 0;"name" = "IMAGES";}' \
	'{"enabled" = 0;"name" = "BOOKMARKS";}' \
	'{"enabled" = 0;"name" = "MUSIC";}' \
	'{"enabled" = 0;"name" = "MOVIES";}' \
	'{"enabled" = 0;"name" = "PRESENTATIONS";}' \
	'{"enabled" = 0;"name" = "SPREADSHEETS";}' \
	'{"enabled" = 0;"name" = "SOURCE";}' \
	'{"enabled" = 0;"name" = "MENU_DEFINITION";}' \
	'{"enabled" = 0;"name" = "MENU_OTHER";}' \
	'{"enabled" = 0;"name" = "MENU_CONVERSION";}' \
	'{"enabled" = 0;"name" = "MENU_EXPRESSION";}' \
	'{"enabled" = 0;"name" = "MENU_WEBSEARCH";}' \
	'{"enabled" = 0;"name" = "MENU_SPOTLIGHT_SUGGESTIONS";}'

echo "  › Load new settings before rebuilding the index"
killall mds > /dev/null 2>&1

echo "  › Make sure indexing is enabled for the main volume"
sudo mdutil -i on / > /dev/null

echo "  › Rebuild the index from scratch"
sudo mdutil -E / > /dev/null

###############################################################################
# Activity Monitor                                                            #
###############################################################################
echo ""
echo "› Activity Monitor:"

echo "  › Show the main window when launching Activity Monitor"
defaults write com.apple.ActivityMonitor OpenMainWindow -bool true

echo "  › Visualize CPU usage in the Activity Monitor Dock icon"
defaults write com.apple.ActivityMonitor IconType -int 5

echo "  › Show all processes in Activity Monitor"
defaults write com.apple.ActivityMonitor ShowCategory -int 0

echo "  › Sort Activity Monitor results by CPU usage"
defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"
defaults write com.apple.ActivityMonitor SortDirection -int 0

###############################################################################
# Address Book, Dashboard, iCal, TextEdit, and Disk Utility                   #
###############################################################################
echo ""
echo "› Address Book, TextEdit, and Disk Utility:"

echo "  › Enable the debug menu in Address Book"
defaults write com.apple.addressbook ABShowDebugMenu -bool true

echo "  › Use plain text mode for new TextEdit documents"
defaults write com.apple.TextEdit RichText -int 0

echo "  › Open and save files as UTF-8 in TextEdit"
defaults write com.apple.TextEdit PlainTextEncoding -int 4
defaults write com.apple.TextEdit PlainTextEncodingForWrite -int 4

echo "  › Enable the debug menu in Disk Utility"
defaults write com.apple.DiskUtility DUDebugMenuEnabled -bool true
defaults write com.apple.DiskUtility advanced-image-options -bool true

echo "  › Auto-play videos when opened with QuickTime Player"
defaults write com.apple.QuickTimePlayerX MGPlayMovieOnOpen -bool true

###############################################################################
# Mac App Store                                                               #
###############################################################################
echo ""
echo "› App Store & Software Update:"

echo "  › Enable the WebKit Developer Tools in the Mac App Store"
defaults write com.apple.appstore WebKitDeveloperExtras -bool true

echo "  › Enable Debug Menu in the Mac App Store"
defaults write com.apple.appstore ShowDebugMenu -bool true

echo "  › Enable the automatic update check"
defaults write com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true

echo "  › Check for software updates daily, not just once per week"
defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1

echo "  › Download newly available updates in background"
defaults write com.apple.SoftwareUpdate AutomaticDownload -int 1

echo "  › Install System data files & security updates"
defaults write com.apple.SoftwareUpdate CriticalUpdateInstall -int 1

echo "  › Automatically download apps purchased on other Macs"
defaults write com.apple.SoftwareUpdate ConfigDataInstall -int 1

echo "  › Turn on app auto-update"
defaults write com.apple.commerce AutoUpdate -bool true

echo "  › Allow the App Store to reboot machine on macOS updates"
defaults write com.apple.commerce AutoUpdateRestartRequired -bool true

###############################################################################
# Messages                                                                    #
###############################################################################
echo ""
echo "› Messages:"

# Disable automatic emoji substitution (i.e. use plain text smileys)
# defaults write com.apple.messageshelper.MessageController SOInputLineSettings -dict-add "automaticEmojiSubstitutionEnablediMessage" -bool false

echo "  › Disable smart quotes as it’s annoying for messages that contain code"
defaults write com.apple.messageshelper.MessageController SOInputLineSettings -dict-add "automaticQuoteSubstitutionEnabled" -bool false

echo "  › Disable continuous spell checking"
defaults write com.apple.messageshelper.MessageController SOInputLineSettings -dict-add "continuousSpellCheckingEnabled" -bool false

###############################################################################
# Tweetbot.app                                                                #
###############################################################################
echo ""
echo "› Tweetbot:"
echo "  › Bypass the annoyingly slow t.co URL shortener"
defaults write com.tapbots.TweetbotMac OpenURLsDirectly -bool true

#############################

echo ""
echo "› Kill related apps"
for app in "Activity Monitor" \
  "Address Book" \
  "Calendar" \
  "Contacts" \
  "cfprefsd" \
  "Dock" \
  "Finder" \
  "Google Chrome" \
  "Mail" \
  "Messages" \
  "Safari" \
  "SystemUIServer" \
  "Terminal" \
  "Transmission" \
  "Tweetbot" \
  "Photos"; do
  killall "$app" >/dev/null 2>&1
done
set -e
