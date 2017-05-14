# libbash gui tests for osascript (macOS)

if [ "$lb_current_os" != macOS ] ; then
	return 0
fi

gui=osascript

# load global tests
source "$(dirname "$(lb_realpath "$BASH_SOURCE")")/00_test_gui.sh"
