#!/bin/bash
echo -p 'github password:' githubpw
echo -p 'coding password:' codingpw

bundle exec jekyll build --destination ./docs
cp ./CNAME ./docs/
touch ./docs/.nojekyll

# touch docs/baidu_sitemap.xml
# sed -e 's/0qinghao.github.io\/inforest/7u7d9c.coding-pages.com/' docs/sitemap.xml> docs/baidu_sitemap.xml

git add -A;git commit -m "$*";
spawn git push origin master;
expect "Password"
send "$githubpw"

cd docs
git add -A;git commit -m "$*";
spawn git push coding master;
expect "Password"
send "$codingpw"
spawn git push githubpage master;
expect "Password"
send "$githubpw"
