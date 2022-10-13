#!/bin/sh
# 设置出错自动退出
set -o errexit

printf "开始更新子仓库……\n\n"

git submodule foreach git checkout .
git submodule foreach git checkout main
git submodule foreach git pull

printf "更新子仓库完成\n\n"

printf "开始编译数字花园……\n\n"

pnpm run build

printf "编译数字花园完成\n\n"

printf "开始部署数字花园……\n\n"
pnpm rimraf release/*
cp -r public/* release/

cd release

# Add changes to git.
git add .

# Commit changes.
msg="更新数字花园 $(date)"
if [ -n "$*" ]; then
	msg="$*"
fi
git commit -m "$msg"

git push

printf "部署数字花园完成\n"

cd ..


printf "开始推送发布工具……\n\n"
# Add changes to git.
git add .
git commit -m "$msg"
git push

printf "推送发布工具完成\n"

exit 0