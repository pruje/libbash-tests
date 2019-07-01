# libbash gui tests for osascript (macOS)

[ "$lb_current_os" != macOS ] && return 0

gui=osascript

# load global tests
source "$(dirname "$(lb_realpath "$BASH_SOURCE")")/00_test_gui.sh"
