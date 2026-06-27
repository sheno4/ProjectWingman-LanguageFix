# Project Wingman Language Fallback Fix / Project Wingman 非英语语言回退修复补丁

A language fallback fix for Project Wingman.
Project Wingman 非英语语言回退修复补丁。

This patch fixes the issue where the game automatically resets back to English after restarting, even if you have already set the in-game language to German, Spanish, French, Japanese, Korean, Russian, Simplified Chinese, or another non-English language.
用于修复游戏内已设置为德语、西语、法语、日语、韩语、俄语、简体中文等非英语语言后，重新进入游戏又自动变回英文的问题。

## Download / 下载

Download the single-file patch from Releases:
从 Release 下载单文件补丁：

[ProjectWingman_Language_Fix.bat](https://github.com/sheno4/ProjectWingman-LanguageFix/releases/latest/download/ProjectWingman_Language_Fix.bat)

## Supported Languages / 支持语言

* Simplified Chinese / 简体中文 `zh-CN`
* German / Deutsch `de-DE`
* Spanish / Español `es-ES`
* French / Français `fr-FR`
* Japanese / 日本語 `ja`
* Korean / 한국어 `ko-KR`
* Russian / Русский `ru-RU`

## Usage / 使用方法

1. Close Project Wingman.
   关闭 Project Wingman。

2. Double-click `ProjectWingman_Language_Fix.bat`.
   双击运行 `ProjectWingman_Language_Fix.bat`。

3. Enter `1` to install the fix or switch the fixed language.
   输入 `1` 安装/切换语言修复。

4. Select the language you want to lock.
   选择你想固定的语言。

5. Launch the game normally from Steam.
   从 Steam 正常启动游戏。

To restore the original file, run the script again and enter `2`.
如果想还原补丁，重新运行脚本并输入 `2`。

## Automatic Game Detection / 自动定位游戏

The script automatically reads the Steam installation path, Steam library folders, and Project Wingman’s AppID `895870` to locate the game. It can be used on another computer as long as Project Wingman is installed normally through Steam.
脚本会自动读取 Steam 安装路径、Steam 库目录和 Project Wingman 的 AppID `895870` 来定位游戏。换一台电脑也可以使用，只要是正常 Steam 安装。

If automatic detection fails, the script will ask you to drag the Project Wingman game folder into the window and press Enter.
如果自动定位失败，脚本会提示你把 Project Wingman 游戏目录拖进窗口后回车。

## How It Works / 原理

This issue is not caused by Steam’s language setting failing. Instead, when the game starts, it writes the language field back to `en-US`.
这个问题不是 Steam 语言设置失效，而是游戏启动时会把语言字段写回 `en-US`。

The patch performs a very small local byte replacement on the game EXE: it maps the `en-US` language slot used during game startup to the target language you selected, and also updates the language fields in the local configuration and save files.
补丁会在本机对游戏 EXE 做一个很小的字节替换：把游戏启动时使用的 `en-US` language slot 映射为你选择的目标语言，并同步修正本地配置和存档里的语言字段。

The patch does not include any original game files and does not distribute a modified game EXE.
补丁不包含游戏原文件，也不会分发修改后的游戏 EXE。

## Restore and Updates / 还原与更新

When installing the fix, the script automatically backs up the original EXE. The backup file is saved in the same folder as the game EXE, with a filename similar to:
安装时会自动备份原 EXE，备份文件会保存在游戏 EXE 同目录，文件名类似：

```text
ProjectWingman-Win64-Shipping.exe.bak-pwlang-YYYYMMDD-HHMMSS
```

Run the script and enter `2` to restore the original EXE. The script can also recognize older `bak-pwzhcn` backups.
运行脚本并输入 `2` 可以还原。脚本也能识别旧版 `bak-pwzhcn` 备份。

After verifying game file integrity through Steam or after a game update, the patch may be overwritten. If that happens, run the script again.
Steam 验证游戏完整性或游戏更新后，补丁可能会被覆盖，需要重新运行脚本。

## Notes / 注意事项

* Recommended only for the legitimate Steam version of Project Wingman.
  仅建议用于 Steam 正版 Project Wingman。

* Non-Steam or pirated versions are not guaranteed to work and are not supported.
  非 Steam/破解版本不保证可用，也不提供适配支持。

* If the game is running, exit the game before applying the patch.
  如果游戏正在运行，请先退出游戏再打补丁。

* If antivirus software blocks the `.bat` file, note that the patch logic is embedded inside this batch file. This repository does not contain the game EXE or any modified game files.
  如果杀毒软件拦截 `.bat`，补丁逻辑内嵌在这个批处理文件中；仓库不包含游戏 EXE 或修改后的游戏文件。

## Checksum / 校验

`ProjectWingman_Language_Fix.bat` v1.1.0 SHA256:

```text
CC7FA29F86353F7DD47281E1BCC868870F99E9F97915CD612E15060D20534A66
```
