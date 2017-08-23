# core filesystem tests

# get fstype
tb_test -c 1 lb_df_fstype
tb_test -c 2 lb_df_fstype notAfile
tb_test lb_df_fstype "$0"


# get space left
tb_test -c 1 lb_df_space_left
tb_test -c 2 lb_df_space_left notAfile
tb_test lb_df_space_left "$0"


# get mount point
tb_test -c 1 lb_df_mountpoint
tb_test -c 2 lb_df_mountpoint notAfile
tb_test lb_df_mountpoint "$0"


# get disk UUID
tb_test -c 1 lb_df_uuid
tb_test -c 2 lb_df_uuid notAfile
tb_test lb_df_uuid "$0"


# avoid skipping tests if last failed
return 0