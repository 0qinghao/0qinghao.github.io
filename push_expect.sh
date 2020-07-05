#!/usr/bin/expect
set githubpw [lindex $argv 0]
set coding [lindex $argv 1]

spawn git push origin master
expect {
    "Password" {send "$githubpw"}
}

cd docs
spawn git push coding master
expect "Password"
send "$codingpw"
spawn git push githubpage master
expect "Password"
send "$githubpw"