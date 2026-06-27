# Project Wingman Language Fallback Fix

Project Wingman 非英语语言回退修复补丁。

用于修复游戏内已设置为德语、西语、法语、日语、韩语、俄语、简体中文等非英语语言后，重新进入游戏又自动变回英文的问题。

## 下载

从 Release 下载单文件补丁：

[ProjectWingman_Language_Fix.bat](https://github.com/sheno4/ProjectWingman-LanguageFix/releases/latest/download/ProjectWingman_Language_Fix.bat)

## 支持语言

- 简体中文 `zh-CN`
- Deutsch `de-DE`
- Español `es-ES`
- Français `fr-FR`
- 日本語 `ja`
- 한국어 `ko-KR`
- Русский `ru-RU`

## 使用方法

1. 关闭 Project Wingman。
2. 双击运行 `ProjectWingman_Language_Fix.bat`。
3. 输入 `1` 安装/切换语言修复。
4. 选择你想固定的语言。
5. 从 Steam 正常启动游戏。

如果想还原补丁，重新运行脚本并输入 `2`。

## 自动定位游戏

脚本会自动读取 Steam 安装路径、Steam 库目录和 Project Wingman 的 AppID `895870` 来定位游戏。换一台电脑也可以使用，只要是正常 Steam 安装。

如果自动定位失败，脚本会提示你把 Project Wingman 游戏目录拖进窗口后回车。

## 原理

这个问题不是 Steam 语言设置失效，而是游戏启动时会把语言字段写回 `en-US`。

补丁会在本机对游戏 EXE 做一个很小的字节替换：把游戏启动时使用的 `en-US` language slot 映射为你选择的目标语言，并同步修正本地配置和存档里的语言字段。

补丁不包含游戏原文件，也不会分发修改后的游戏 EXE。

## 还原与更新

安装时会自动备份原 EXE，备份文件会保存在游戏 EXE 同目录，文件名类似：

```text
ProjectWingman-Win64-Shipping.exe.bak-pwlang-YYYYMMDD-HHMMSS
```

运行脚本并输入 `2` 可以还原。脚本也能识别旧版 `bak-pwzhcn` 备份。

Steam 验证游戏完整性或游戏更新后，补丁可能会被覆盖，需要重新运行脚本。

## 注意事项

- 仅建议用于 Steam 正版 Project Wingman。
- 非 Steam/破解版本不保证可用，也不提供适配支持。
- 如果游戏正在运行，请先退出游戏再打补丁。
- 如果杀毒软件拦截 `.bat`，补丁逻辑内嵌在这个批处理文件中；仓库不包含游戏 EXE 或修改后的游戏文件。

## 校验

`ProjectWingman_Language_Fix.bat` v1.1.0 SHA256:

```text
CC7FA29F86353F7DD47281E1BCC868870F99E9F97915CD612E15060D20534A66
```
