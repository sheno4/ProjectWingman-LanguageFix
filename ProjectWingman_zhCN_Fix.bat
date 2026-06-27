@echo off
chcp 65001 >nul
set "_PW_FIX_SELF=%~f0"
powershell -NoProfile -ExecutionPolicy Bypass -Command "$p=$env:_PW_FIX_SELF; $lines=Get-Content -LiteralPath $p -Encoding UTF8; $m='::'+' PW_PS_PAYLOAD'; $i=[Array]::IndexOf($lines,$m); if($i -lt 0){throw 'payload not found'}; $sb=New-Object Text.StringBuilder; for($n=$i+1;$n -lt $lines.Count;$n++){ if($lines[$n].StartsWith('::PS ')){ [void]$sb.AppendLine($lines[$n].Substring(5)) } }; Invoke-Expression $sb.ToString()"
echo.
pause
exit /b

:: PW_PS_PAYLOAD
::PS $ErrorActionPreference = "Stop"
::PS [Console]::OutputEncoding = [Text.Encoding]::UTF8
::PS 
::PS function Info($m) { Write-Host "[Project Wingman 中文修复] $m" }
::PS function Stop-WithMessage($m) { Write-Host ""; Write-Host "错误：$m" -ForegroundColor Red; exit 1 }
::PS 
::PS Add-Type -TypeDefinition @"
::PS using System;
::PS using System.Collections.Generic;
::PS public static class ByteFind {
::PS     public static long[] Find(byte[] data, byte[] pat) {
::PS         var r = new List<long>();
::PS         if (data == null || pat == null || pat.Length == 0 || data.Length < pat.Length) return r.ToArray();
::PS         int max = data.Length - pat.Length;
::PS         for (int i = 0; i <= max; i++) {
::PS             if (data[i] != pat[0]) continue;
::PS             bool ok = true;
::PS             for (int j = 1; j < pat.Length; j++) {
::PS                 if (data[i + j] != pat[j]) { ok = false; break; }
::PS             }
::PS             if (ok) r.Add(i);
::PS         }
::PS         return r.ToArray();
::PS     }
::PS }
::PS "@
::PS 
::PS function Exe-FromRoot($root) {
::PS     if ([string]::IsNullOrWhiteSpace($root)) { return $null }
::PS     $a = Join-Path $root "ProjectWingman\Binaries\Win64\ProjectWingman-Win64-Shipping.exe"
::PS     $b = Join-Path $root "Binaries\Win64\ProjectWingman-Win64-Shipping.exe"
::PS     if (Test-Path -LiteralPath $a) { return (Resolve-Path -LiteralPath $a).Path }
::PS     if (Test-Path -LiteralPath $b) { return (Resolve-Path -LiteralPath $b).Path }
::PS     return $null
::PS }
::PS 
::PS function Exe-FromManifest($manifest) {
::PS     if (-not (Test-Path -LiteralPath $manifest)) { return $null }
::PS     $txt = Get-Content -LiteralPath $manifest -Raw
::PS     $m = [regex]::Match($txt, '"installdir"\s+"([^"]+)"')
::PS     if (-not $m.Success) { return $null }
::PS     $steamapps = Split-Path -Parent $manifest
::PS     $root = Join-Path (Join-Path $steamapps "common") $m.Groups[1].Value
::PS     return Exe-FromRoot $root
::PS }
::PS 
::PS function Add-Path($list, $path) {
::PS     if (-not [string]::IsNullOrWhiteSpace($path) -and (Test-Path -LiteralPath $path)) {
::PS         $r = (Resolve-Path -LiteralPath $path).Path
::PS         if (-not $list.Contains($r)) { [void]$list.Add($r) }
::PS     }
::PS }
::PS 
::PS function Find-GameExe {
::PS     $roots = New-Object "System.Collections.Generic.List[string]"
::PS 
::PS     foreach ($k in "HKCU:\Software\Valve\Steam","HKLM:\SOFTWARE\WOW6432Node\Valve\Steam","HKLM:\SOFTWARE\Valve\Steam") {
::PS         try {
::PS             $v = Get-ItemProperty -Path $k -ErrorAction Stop
::PS             Add-Path $roots $v.SteamPath
::PS             Add-Path $roots $v.InstallPath
::PS         } catch {}
::PS     }
::PS 
::PS     foreach ($d in Get-PSDrive -PSProvider FileSystem) {
::PS         Add-Path $roots (Join-Path $d.Root "Steam")
::PS         Add-Path $roots (Join-Path $d.Root "steam")
::PS         Add-Path $roots (Join-Path $d.Root "SteamLibrary")
::PS     }
::PS 
::PS     $candidates = New-Object "System.Collections.Generic.List[string]"
::PS     foreach ($r in $roots) {
::PS         $exe = Exe-FromManifest (Join-Path $r "steamapps\appmanifest_895870.acf")
::PS         if ($exe) { return $exe }
::PS         Add-Path $candidates (Join-Path $r "steamapps\common\Project Wingman")
::PS 
::PS         $vdf = Join-Path $r "steamapps\libraryfolders.vdf"
::PS         if (-not (Test-Path -LiteralPath $vdf)) { $vdf = Join-Path $r "config\libraryfolders.vdf" }
::PS         if (Test-Path -LiteralPath $vdf) {
::PS             $txt = Get-Content -LiteralPath $vdf -Raw
::PS             foreach ($m in [regex]::Matches($txt, '"path"\s+"([^"]+)"')) {
::PS                 $lib = $m.Groups[1].Value
::PS                 $exe = Exe-FromManifest (Join-Path $lib "steamapps\appmanifest_895870.acf")
::PS                 if ($exe) { return $exe }
::PS                 Add-Path $candidates (Join-Path $lib "steamapps\common\Project Wingman")
::PS             }
::PS         }
::PS     }
::PS 
::PS     foreach ($c in $candidates) {
::PS         $exe = Exe-FromRoot $c
::PS         if ($exe) { return $exe }
::PS     }
::PS 
::PS     Write-Host ""
::PS     Write-Host "没有自动找到游戏目录。"
::PS     $manual = Read-Host "请把 Project Wingman 游戏目录拖进来后回车"
::PS     $manual = $manual.Trim('"')
::PS     $exe = Exe-FromRoot $manual
::PS     if ($exe) { return $exe }
::PS     Stop-WithMessage "这个目录里找不到 ProjectWingman-Win64-Shipping.exe"
::PS }
::PS 
::PS function Backup($path) {
::PS     $bak = "$path.bak-pwzhcn-" + (Get-Date -Format "yyyyMMdd-HHmmss")
::PS     Copy-Item -LiteralPath $path -Destination $bak -Force
::PS     return $bak
::PS }
::PS 
::PS function Patch-UserFiles {
::PS     $ini = Join-Path $env:LOCALAPPDATA "ProjectWingman\Saved\Config\WindowsNoEditor\GameUserSettings.ini"
::PS     if (Test-Path -LiteralPath $ini) {
::PS         $t = Get-Content -LiteralPath $ini -Raw
::PS         if ($t -notmatch "(?m)^Culture=zh-CN\s*$") {
::PS             Backup $ini | Out-Null
::PS             if ($t -match "(?m)^Culture=.*$") { $t = $t -replace "(?m)^Culture=.*$", "Culture=zh-CN" }
::PS             elseif ($t -match "(?m)^\[Internationalization\]\s*$") { $t = $t -replace "(?m)^(\[Internationalization\]\s*)$", "`$1`r`nCulture=zh-CN" }
::PS             else { $t = "[Internationalization]`r`nCulture=zh-CN`r`n`r`n" + $t }
::PS             Set-Content -LiteralPath $ini -Value $t -NoNewline -Encoding ASCII
::PS         }
::PS         Info "配置已设为 zh-CN"
::PS     }
::PS 
::PS     $sav = Join-Path $env:LOCALAPPDATA "ProjectWingman\Saved\SaveGames\savegame.sav"
::PS     if (Test-Path -LiteralPath $sav) {
::PS         $en = [Text.Encoding]::ASCII.GetBytes("en-US" + [char]0)
::PS         $zh = [Text.Encoding]::ASCII.GetBytes("zh-CN" + [char]0)
::PS         $b = [IO.File]::ReadAllBytes($sav)
::PS         $hits = [ByteFind]::Find($b, $en)
::PS         if ($hits.Count -gt 0) {
::PS             Backup $sav | Out-Null
::PS             foreach ($o in $hits) { [Array]::Copy($zh, 0, $b, [int]$o, $zh.Length) }
::PS             [IO.File]::WriteAllBytes($sav, $b)
::PS         }
::PS         Info "存档语言已设为 zh-CN"
::PS     }
::PS }
::PS 
::PS function Install-Fix($exe) {
::PS     $en = [Text.Encoding]::Unicode.GetBytes("en-US" + [char]0)
::PS     $zh = [Text.Encoding]::Unicode.GetBytes("zh-CN" + [char]0)
::PS     $b = [IO.File]::ReadAllBytes($exe)
::PS     $enHits = [ByteFind]::Find($b, $en)
::PS     $zhHits = [ByteFind]::Find($b, $zh)
::PS 
::PS     if ($enHits.Count -eq 1) {
::PS         $bak = Backup $exe
::PS         [Array]::Copy($zh, 0, $b, [int]$enHits[0], $zh.Length)
::PS         [IO.File]::WriteAllBytes($exe, $b)
::PS         Info "补丁已安装，已备份原文件：$bak"
::PS     } elseif ($enHits.Count -eq 0 -and $zhHits.Count -ge 2) {
::PS         Info "游戏 EXE 已经是修复状态"
::PS     } else {
::PS         Stop-WithMessage "EXE 特征不符合预期，可能是游戏版本更新了。没有修改文件。"
::PS     }
::PS 
::PS     Patch-UserFiles
::PS     Write-Host ""
::PS     Write-Host "完成。现在从 Steam 正常启动游戏即可。" -ForegroundColor Green
::PS }
::PS 
::PS function Restore-Fix($exe) {
::PS     $dir = Split-Path -Parent $exe
::PS     $name = Split-Path -Leaf $exe
::PS     $bak = Get-ChildItem -LiteralPath $dir -Filter "$name.bak-pwzhcn-*" |
::PS         Sort-Object LastWriteTime -Descending |
::PS         Select-Object -First 1
::PS     if (-not $bak) {
::PS         $bak = Get-ChildItem -LiteralPath $dir -Filter "$name.bak-*" |
::PS             Sort-Object LastWriteTime -Descending |
::PS             Select-Object -First 1
::PS     }
::PS     if (-not $bak) { Stop-WithMessage "找不到备份文件，无法还原。" }
::PS     Copy-Item -LiteralPath $bak.FullName -Destination $exe -Force
::PS     Write-Host ""
::PS     Info "已还原：$($bak.FullName)"
::PS }
::PS 
::PS Clear-Host
::PS Write-Host "Project Wingman 简体中文语言回退修复" -ForegroundColor Cyan
::PS Write-Host ""
::PS Write-Host "用途：修复游戏进了又变英文的问题。"
::PS Write-Host "原理：把游戏启动时写回 en-US 的分支改成 zh-CN，并修正本地配置/存档。"
::PS Write-Host "说明：自动读取 Steam 库/AppID 895870；安装时会自动备份原 EXE。"
::PS Write-Host ""
::PS Write-Host "1. 安装/重新修复"
::PS Write-Host "2. 还原补丁"
::PS Write-Host "3. 退出"
::PS Write-Host ""
::PS $choice = Read-Host "请选择"
::PS if ($choice -eq "3") { exit 0 }
::PS 
::PS $running = Get-Process -Name "ProjectWingman*" -ErrorAction SilentlyContinue
::PS if ($running) { Stop-WithMessage "游戏正在运行，请先关闭 Project Wingman。" }
::PS 
::PS $exe = Find-GameExe
::PS Info "找到游戏：$exe"
::PS 
::PS if ($choice -eq "2") { Restore-Fix $exe }
::PS else { Install-Fix $exe }
::PS 
