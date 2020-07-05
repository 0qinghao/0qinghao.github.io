#!/usr/bin/expect
set githubpw [lindex $argv 0]
set codingpw [lindex $argv 1]

spawn git push origin master
expect {
    "Password*" {send "$githubpw\r\n"}
}

cd docs
spawn git push coding master
expect "Password*"
send "$codingpw\r\n"
spawn git push githubpage master
expect "Password*"
send "$githubpw\r\n"