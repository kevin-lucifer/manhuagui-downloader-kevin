#!/bin/bash
# 同步上游仓库 https://github.com/lanyeeee/manhuagui-downloader 的更新

set -e

UPSTREAM_URL="https://github.com/lanyeeee/manhuagui-downloader.git"
UPSTREAM_BRANCH="main"
LOCAL_BRANCH="main"

echo "=========================================="
echo "  同步上游仓库: $UPSTREAM_URL"
echo "=========================================="
echo ""

# 检查是否在 git 仓库目录
if [ ! -d ".git" ]; then
    echo "错误: 当前目录不是 git 仓库"
    exit 1
fi

# 添加上游远程仓库（如果不存在）
if ! git remote | grep -q "upstream"; then
    echo "[1/5] 添加上游远程仓库..."
    git remote add upstream "$UPSTREAM_URL"
    echo "✓ 已添加 upstream: $UPSTREAM_URL"
else
    echo "[1/5] 上游远程仓库已存在"
    # 更新上游 URL（以防有变化）
    git remote set-url upstream "$UPSTREAM_URL"
fi
echo ""

# 获取上游更新
echo "[2/5] 获取上游更新..."
git fetch upstream
echo "✓ 已获取上游更新"
echo ""

# 显示上游最新提交
echo "[3/5] 上游最新提交:"
git log --oneline -3 "upstream/$UPSTREAM_BRANCH"
echo ""

# 保存当前分支
current_branch=$(git branch --show-current)

# 切换到主分支
echo "[4/5] 合并上游更新到本地 $LOCAL_BRANCH 分支..."
if [ "$current_branch" != "$LOCAL_BRANCH" ]; then
    git checkout "$LOCAL_BRANCH"
fi

# 合并上游更新
git merge "upstream/$UPSTREAM_BRANCH" --no-edit
echo "✓ 合并完成"
echo ""

# 推送到自己的远程仓库
echo "[5/5] 推送到 origin $LOCAL_BRANCH..."
git push origin "$LOCAL_BRANCH"
echo "✓ 推送完成"
echo ""

echo "=========================================="
echo "  同步完成!"
echo "=========================================="
echo ""
echo "本地提交记录:"
git log --oneline -3
