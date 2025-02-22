# 复制 baidu 和 google 开头的文件
Copy-Item -Path ./baidu* -Destination ./docs
Copy-Item -Path ./google* -Destination ./docs

# 创建 .nojekyll 文件（如果存在则覆盖）
New-Item -Path ./docs/.nojekyll -ItemType File -Force

# Git 操作
git add -A
git commit -m "$($args -join ' ')"
git push origin master
