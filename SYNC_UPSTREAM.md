# 同步上游仓库说明

本项目是从 https://github.com/lanyeeee/manhuagui-downloader fork 而来的。

## 同步脚本

提供了两个脚本来同步上游仓库的更新：

### 1. Git Bash / Linux / macOS

```bash
./sync-upstream.sh
```

### 2. Windows CMD / PowerShell

```cmd
sync-upstream.bat
```

或者直接双击运行 `sync-upstream.bat`

## 脚本功能

脚本会自动执行以下操作：

1. **添加上游远程仓库**（如果不存在）
   - 上游地址：`https://github.com/lanyeeee/manhuagui-downloader.git`

2. **获取上游更新**
   - `git fetch upstream`

3. **显示上游最新提交**
   - 显示最近3条提交记录

4. **合并到本地主分支**
   - 合并 `upstream/main` 到本地 `main` 分支

5. **推送到你的远程仓库**
   - `git push origin main`

## 手动同步（如果脚本失效）

```bash
# 1. 添加上游仓库（只需执行一次）
git remote add upstream https://github.com/lanyeeee/manhuagui-downloader.git

# 2. 获取上游更新
git fetch upstream

# 3. 合并到本地主分支
git checkout main
git merge upstream/main

# 4. 推送到你的远程仓库
git push origin main
```

## 注意事项

- **冲突处理**：如果上游代码和你的修改有冲突，需要手动解决冲突后再提交
- **备份**：建议在同步前备份你的重要修改
- **频率**：建议定期同步以获取上游的最新功能和修复

## 查看当前远程仓库

```bash
git remote -v
```

预期输出：
```
origin  https://github.com/kevin-lucifer/manhuagui-downloader-kevin.git (fetch)
origin  https://github.com/kevin-lucifer/manhuagui-downloader-kevin.git (push)
upstream        https://github.com/lanyeeee/manhuagui-downloader.git (fetch)
upstream        https://github.com/lanyeeee/manhuagui-downloader.git (push)
```
