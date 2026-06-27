# Project Wingman zh-CN Language Fix

Project Wingman 简体中文语言回退修复补丁。

用于修复部分环境下“游戏内已经设置为中文，但重新进入游戏后又自动变回英文”的问题。

## 下载

请从 Release 页面下载：

[ProjectWingman_zhCN_Fix.bat](https://github.com/qqqqqc1/ProjectWingman-zhCN-LanguageFix/releases/latest/download/ProjectWingman_zhCN_Fix.bat)

## 使用方法

1. 关闭 Project Wingman。
2. 双击运行 `ProjectWingman_zhCN_Fix.bat`。
3. 输入 `1` 安装/重新修复。
4. 从 Steam 正常启动游戏。

如果想还原补丁，重新运行脚本并输入 `2`。

## 自动定位游戏

脚本会自动读取 Steam 安装路径、Steam 库目录和 Project Wingman 的 AppID `895870` 来定位游戏。

如果自动定位失败，脚本会提示你把 Project Wingman 游戏目录拖进窗口后回车。

## 原理

这个问题不是 Steam 语言设置失效，而是游戏启动时会把语言字段写回 `en-US`。

补丁会在本机对游戏 EXE 做一个很小的字节替换：把启动时使用的 `en-US` culture 分支映射为 `zh-CN`，并同步修正本地配置和存档里的语言字段。

补丁不包含游戏原文件，也不会分发修改后的游戏 EXE。

## 还原与更新

安装时会自动备份原 EXE，备份文件会保存在游戏 EXE 同目录，文件名类似：

```text
ProjectWingman-Win64-Shipping.exe.bak-pwzhcn-YYYYMMDD-HHMMSS
```

运行脚本并输入 `2` 可以还原。

Steam 验证游戏完整性或游戏更新后，补丁可能会被覆盖，需要重新运行脚本。

## 注意事项

- 仅建议用于 Steam 正版 Project Wingman。
- 非 Steam/破解版本不保证可用，也不提供适配支持。
- 如果游戏正在运行，请先退出游戏再打补丁。
- 如果杀毒软件拦截 `.bat`，可以查看脚本内容确认；补丁源码就是这个批处理文件本身。

## 校验

`ProjectWingman_zhCN_Fix.bat` v1.0.0 SHA256:

```text
92F8679E27E2B7D4C335D4FDA61B90E5382E93BCB7FCA19DD78E720882D3FB63
```
