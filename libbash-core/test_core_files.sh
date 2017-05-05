# core files tests

# get homepath
tb_test lb_homepath
tb_test lb_homepath $(whoami)
tb_test -c 1 lb_homepath notAuser


# test if directory is empty
tb_test -c 1 lb_dir_is_empty
tb_test -c 1 lb_dir_is_empty notAdirectory
tb_test -c 1 lb_dir_is_empty "$0"   # not a directory

if [ "$lb_current_os" != "macOS" ] ; then
	tb_test -c 2 lb_dir_is_empty /root
fi
tb_test -c 3 lb_dir_is_empty /


# test with an empty directory
nulldir="emptyDirectory0001"
tb_test mkdir "$nulldir" && tb_test lb_dir_is_empty "$nulldir"
rmdir "$nulldir" 2> /dev/null


# abspath
tb_test -c 1 lb_abspath
tb_test -c 2 lb_abspath badDirectory/file.txt
tb_test -i lb_abspath "$0"


# realpath
tb_test -c 1 lb_realpath
tb_test -c 1 lb_realpath notAFile
tb_test lb_realpath "$0"


# avoid skipping tests if last failed
return 0
