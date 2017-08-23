# core filesystem tests

# get fstype
tb_test -c 1 lb_df_fstype
tb_test -c 2 lb_df_fstype notAfile
tb_test lb_df_fstype .


# get space left
tb_test -c 1 lb_df_space_left
tb_test -c 2 lb_df_space_left notAfile
tb_test lb_df_space_left .


# get mount point
tb_test -c 1 lb_df_mountpoint
tb_test -c 2 lb_df_mountpoint notAfile
tb_test lb_df_mountpoint .


# get disk UUID
if [ "$lb_current_os" == Windows ] ; then
	tb_test -c 4 lb_df_uuid .
else
	tb_test -c 1 lb_df_uuid
	tb_test -c 2 lb_df_uuid notAfile
	tb_test lb_df_uuid .
fi


# avoid skipping tests if last failed
return 0
