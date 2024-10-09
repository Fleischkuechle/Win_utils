@REM @echo off
@REM setlocal enabledelayedexpansion

@REM REM Get the directory path where the batch file is located
@REM set "batch_path=%~dp0"

@REM REM Loop through each subfolder and get its size
@REM for /d %%i in ("%batch_path%*") do (
@REM     for /f %%a in ('powershell "(Get-ChildItem '%%i' -Recurse | Measure-Object -Property Length -Sum).Sum"') do (
@REM         set "size=%%a"
@REM         for %%F in ("%%i") do echo %%~nxF Size: !size! bytes
@REM     )
@REM )

@REM pause




@REM @echo off
@REM setlocal enabledelayedexpansion

@REM REM Get the directory path where the batch file is located
@REM set "batch_path=%~dp0"

@REM REM Loop through each subfolder and get its size
@REM for /d %%i in ("%batch_path%*") do (
@REM     for /f %%a in ('powershell "(Get-ChildItem '%%i' -Recurse | Measure-Object -Property Length -Sum).Sum"') do (
@REM         set "size=%%a"
@REM         for %%F in ("%%i") do echo Size: !size! bytes - Folder: %%~nxF
@REM     )
@REM )

@REM pause


@REM REM this is showing the size in mb if smaller as 1MB its showing 0

@REM @echo off
@REM setlocal enabledelayedexpansion

@REM REM Get the directory path where the batch file is located
@REM set "batch_path=%~dp0"

@REM REM Loop through each subfolder and get its size
@REM for /d %%i in ("%batch_path%*") do (
@REM     for /f %%a in ('powershell "(Get-ChildItem '%%i' -Recurse | Measure-Object -Property Length -Sum).Sum"') do (
@REM         set "size=%%a"
        
@REM         REM Convert bytes to megabytes
@REM         set /a "size_mb=size / 1048576"
        
@REM         for %%F in ("%%i") do echo Size: !size_mb! MB - Folder: %%~nxF
@REM     )
@REM )

@REM pause



@REM @echo off
@REM setlocal enabledelayedexpansion

@REM REM Get the directory path where the batch file is located
@REM set "batch_path=%~dp0"

@REM REM Loop through each subfolder and get its size
@REM for /d %%i in ("%batch_path%*") do (
@REM     for /f %%a in ('powershell "(Get-ChildItem '%%i' -Recurse | Measure-Object -Property Length -Sum).Sum"') do (
@REM         set "size=%%a"
        
@REM         REM Convert bytes to megabytes
@REM         set /a "size_mb=size / 1048576"
        
@REM         REM Display 0MB if size is smaller than 1MB
@REM         if !size_mb! equ 0 set "size_mb=0"
        
@REM         for %%F in ("%%i") do echo Size: !size_mb! MB - Folder: %%~nxF
@REM     )
@REM )

@REM pause





@echo off
setlocal enabledelayedexpansion

REM Get the directory path where the batch file is located
set "batch_path=%~dp0"

REM Loop through each subfolder and get its size
for /d %%i in ("%batch_path%*") do (
    for /f %%a in ('powershell "(Get-ChildItem '%%i' -Recurse | Measure-Object -Property Length -Sum).Sum"') do (
        set "size=%%a"
        
        REM Convert bytes to megabytes
        set /a "size_mb=size / 1048576"
        
        REM Display folders bigger than 1MB
        if !size_mb! gtr 1 (
            for %%F in ("%%i") do echo Size: !size_mb! MB - Folder: %%~nxF
        )
    )
)

pause
