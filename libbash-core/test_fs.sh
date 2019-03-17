# core filesystem tests

# get fstype
tb_test -c 1 lb_df_fstype
tb_test -c 2 lb_df_fstype notAfile
tb_test lb_df_fstype . && \
tb_test -n 'lb_df_fstype not empty' [ -n "$(lb_df_fstype .)" ]


# get space left
tb_test -c 1 lb_df_space_left
tb_test -c 2 lb_df_space_left notAfile
tb_test lb_df_space_left . && \
tb_test -n 'lb_df_space_left not empty' [ -n "$(lb_df_space_left .)" ]


# get mount point
tb_test -c 1 lb_df_mountpoint
tb_test -c 2 lb_df_mountpoint notAfile
tb_test lb_df_mountpoint . && \
tb_test -n 'lb_df_mountpoint not empty' [ -n "$(lb_df_mountpoint .)" ]

# get disk UUID
case $lb_current_os in
	BSD|Windows)
		# not compatible with those OS
		tb_test -c 4 lb_df_uuid .
		;;
	*)
		tb_test -c 1 lb_df_uuid
		tb_test -c 2 lb_df_uuid notAfile
		tb_test lb_df_uuid . && \
		tb_test -n 'lb_df_uuid not empty' [ -n "$(lb_df_uuid .)" ]
		;;
esac


# avoid skipping tests if last failed
return 0
