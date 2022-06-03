# interaction tests

# use input
tb_test -c 1 lb_input_text
tb_test -i lb_input_text -n "Please enter 'xxx':" << EOF
xxx
EOF
tb_test -r xxx -v "$lb_input_text"

tb_test -i lb_input_text -d "zzz" "Please enter nothing." << EOF
EOF
tb_test -r zzz -v "$lb_input_text"


# input password
tb_test -c 1 lb_input_password -l
tb_test -i -c 2 lb_input_password << EOF
EOF

tb_test -i -c 3 lb_input_password -c << EOF
xxx
yyy
EOF

tb_test -i -c 4 lb_input_password -m 4 << EOF
xxx
EOF

tb_test -i lb_input_password -m 3 << EOF
xxx
EOF

tb_test -i lb_input_password "Please enter password 'xxx':" << EOF
xxx
EOF
tb_test -r xxx -v "$lb_input_password"

tb_test -i lb_input_password -c --confirm-label "Confirm xxx:" "Please enter password 'xxx':" << EOF
xxx
xxx
EOF
tb_test -r xxx -v "$lb_input_password"


# yes or no
tb_test -c 1 lb_yesno
tb_test -i lb_yesno "Do you want to continue?" << EOF
$in_yes
EOF

tb_test -i lb_yesno -y --yes-label "yes" "Happy?" << EOF
yes
EOF

tb_test -i -c 2 lb_yesno "Say no?" << EOF
EOF

tb_test -i -c 3 lb_yesno -c "Cancel?" << EOF
$in_cancel
EOF


# choose option
tb_test -c 1 lb_choose_option -l BadChoice
tb_test -i lb_choose_option -l "ChooseOption2:" one two three << EOF
2
EOF
tb_test -r 2 -v $lb_choose_option

tb_test -i lb_choose_option -d 1 -l "TypeEnter:" ok << EOF
EOF
tb_test -r 1 -v $lb_choose_option

tb_test -i -c 2 lb_choose_option cancel << EOF
EOF

tb_test -i -c 2 lb_choose_option -l "Type.cancel:" -c cancel a b c << EOF
cancel
EOF

tb_test -i -c 3 lb_choose_option choose a bad option << EOF
9999
EOF

tb_test -i -c 3 lb_choose_option a b c << EOF
1,2
EOF

tb_test -i lb_choose_option -m a b c << EOF
1,3,3,1
EOF
tb_test -r "1 3" -v "${lb_choose_option[@]}"

tb_test lb_say "Hello. This is a speech test."

# avoid skipping tests if last failed
true
