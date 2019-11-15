# libbash gui tests for cscript (only on Windows)

[ "$lb_current_os" != Windows ] && return 0

gui=cscript

# load global tests
source "$(dirname "$(lb_realpath "$BASH_SOURCE")")"/00_test_gui.sh
