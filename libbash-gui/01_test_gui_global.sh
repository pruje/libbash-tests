# libbash gui global tests

# get GUI
tb_test -r "$lbg__gui" lbg_get_gui

# set bad GUI
tb_test -i -c 1 lbg_set_gui badGUItool

# display
tb_test -c 1 lbg_display_info
tb_test -c 1 lbg_display_warning
tb_test -c 1 lbg_display_error
tb_test -c 1 lbg_display_debug

# notifications
tb_test -c 1 lbg_notify

# input text
tb_test -c 1 lbg_input_text

# input password
tb_test -c 1 lbg_input_password -l

# yes/no dialog
tb_test -c 1 lbg_yesno

# choose option
tb_test -c 1 lbg_choose_option

# choose directory
tb_test -c 1 lbg_choose_directory notAdirectory

# choose file
tb_test -c 1 lbg_choose_file notAvalidPath

# open directory
tb_test -c 1 lbg_open_directory badDirectory
tb_test -c 1 lbg_open_directory -e
tb_test -c 2 lbg_open_directory -e badCommand

# avoid skipping tests if last failed
return 0
