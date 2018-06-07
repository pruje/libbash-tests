# core files tests

# get homepath
tb_test lb_homepath
tb_test lb_homepath $(whoami)
tb_test -c 1 lb_homepath notAuser


# test if directory is empty
tb_test -c 1 lb_is_dir_empty
tb_test -c 1 lb_is_dir_empty notAdirectory
tb_test -c 1 lb_is_dir_empty "$0"   # not a directory

if [ "$lb_current_os" == "Linux" ] ; then
	tb_test -c 2 lb_is_dir_empty /root
fi

tb_test -c 3 lb_is_dir_empty /

# test with an empty directory
nulldir="emptyDirectory0001"
tb_test mkdir "$nulldir" && tb_test lb_is_dir_empty "$nulldir"
rmdir "$nulldir" 2> /dev/null


# abspath
tb_test -c 1 lb_abspath
tb_test -c 2 lb_abspath badDirectory/file.txt
tb_test -i lb_abspath "$0"


# realpath
tb_test -c 1 lb_realpath
tb_test -c 1 lb_realpath notAFile
tb_test lb_realpath "$0"

# realpaths on windows
if [ "$lb_current_os" == "Windows" ] ; then
	tb_test -r "/cygdrive/c/Users" lb_realpath "C:\\Users\\"
fi


# is writable
tb_test lb_is_writable .
tb_test -c 1 lb_is_writable
tb_test -c 2 lb_is_writable /
tb_test -c 3 lb_is_writable /badFolder
tb_test -c 4 lb_is_writable /badDirectory/badSubDirectory


# edit file
tb_test -c 1 lb_edit
tb_test -c 4 lb_edit badFile

tb_testfile="./testfile.txt"

if echo 123 > "$tb_testfile" ; then
	tb_test lb_edit 's/2/4/' "$tb_testfile"
	tb_test -r 143 cat "$tb_testfile"
else
	tb_test false
fi

rm -f "$tb_testfile"

# avoid skipping tests if last failed
return 0
