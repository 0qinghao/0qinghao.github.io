#!/bin/bash
read -s -p 'github password:' githubpw
echo
read -s -p 'coding password:' codingpw
echo

bundle exec jekyll build --destination ./docs
cp ./CNAME ./docs/
touch ./docs/.nojekyll
git add -A;git commit -m "$*";
cd docs
git add -A;git commit -m "$*";
cd ..
# touch docs/baidu_sitemap.xml
# sed -e 's/0qinghao.github.io\/inforest/7u7d9c.coding-pages.com/' docs/sitemap.xml> docs/baidu_sitemap.xml
/usr/bin/expect <<-EOF
spawn git push origin master;
expect "Password"
send "$githubpw"

cd docs
spawn git push coding master;
expect "Password"
send "$codingpw"
spawn git push githubpage master;
expect "Password"
send "$githubpw"
expect eof
exit 0
EOF