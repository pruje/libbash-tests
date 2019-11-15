# libbash gui tests for zenity

gui=zenity

# if not installed, do not test
lb_command_exists $gui || return 0

# load global tests
source "$(dirname "$(lb_realpath "$BASH_SOURCE")")"/00_test_gui.sh
