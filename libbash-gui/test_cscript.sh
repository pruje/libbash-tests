# libbash gui tests for cscript (Windows)

if [ "$lb_current_os" != Windows ] ; then
	return 0
fi

gui=cscript

# load global tests
source "$(dirname "$(lb_realpath "$BASH_SOURCE")")/00_test_gui.sh"
