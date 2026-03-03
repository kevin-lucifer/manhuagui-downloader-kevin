@echo off
chcp 65001 >nul
REM 同步上游仓库 https://github.com/lanyeeee/manhuagui-downloader 的更新

set UPSTREAM_URL=https://github.com/lanyeeee/manhuagui-downloader.git
set UPSTREAM_BRANCH=main
set LOCAL_BRANCH=main

echo ==========================================
echo   同步上游仓库: %UPSTREAM_URL%
echo ==========================================
echo.

REM 检查是否在 git 仓库目录
if not exist ".git" (
    echo 错误: 当前目录不是 git 仓库
    exit /b 1
)

REM 添加上游远程仓库（如果不存在）
git remote | findstr "upstream" >nul
if errorlevel 1 (
    echo [1/5] 添加上游远程仓库...
    git remote add upstream %UPSTREAM_URL%
    echo ✓ 已添加 upstream: %UPSTREAM_URL%
) else (
    echo [1/5] 上游远程仓库已存在
    REM 更新上游 URL（以防有变化）
    git remote set-url upstream %UPSTREAM_URL%
)
echo.

REM 获取上游更新
echo [2/5] 获取上游更新...
git fetch upstream
echo ✓ 已获取上游更新
echo.

REM 显示上游最新提交
echo [3/5] 上游最新提交:
git log --oneline -3 upstream/%UPSTREAM_BRANCH%
echo.

REM 获取当前分支
for /f "tokens=*" %%a in ('git branch --show-current') do set current_branch=%%a

REM 切换到主分支
echo [4/5] 合并上游更新到本地 %LOCAL_BRANCH% 分支...
if not "%current_branch%"=="%LOCAL_BRANCH%" (
    git checkout %LOCAL_BRANCH%
)

REM 合并上游更新
git merge upstream/%UPSTREAM_BRANCH% --no-edit
echo ✓ 合并完成
echo.

REM 推送到自己的远程仓库
echo [5/5] 推送到 origin %LOCAL_BRANCH%...
git push origin %LOCAL_BRANCH%
echo ✓ 推送完成
echo.

echo ==========================================
echo   同步完成!
echo ==========================================
echo.
echo 本地提交记录:
git log --oneline -3

pause
