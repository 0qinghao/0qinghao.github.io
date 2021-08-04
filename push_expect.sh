#!/usr/bin/expect
set githubpw [lindex $argv 0]
# set codingpw [lindex $argv 1]

cd ../0qinghao.github.io
# spawn git push coding master
# expect {
#     "Password*" {send "$codingpw\n"}
# }
# expect eof

spawn git push origin master
expect {
    "Password*" {send "$githubpw\n"}
}
expect eof

cd ../jekyll.0qinghao.github.io
spawn git push origin master
expect {
    "Password*" {send "$githubpw\n"}
}
expect eof