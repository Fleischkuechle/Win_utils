@echo off
setlocal enabledelayedexpansion
REM double click me an i will print all folder path that are longer as path_length
REM change the path_length to get diffrent results
set path_length=100
echo start printing all pathes that are longer as %path_length% characters.
set "batch_path=%~dp0"
for /r "%batch_path%" %%F in (*) do (
    set "path=%%~fF"
    if "!path:~%path_length%!" neq "" (
        echo !path!
    )
)
echo printed all pathes that are longer as %path_length% characters.
echo path length checker completed..

pause




@REM set "batch_path=%~dp0"
@REM for /r "%batch_path%" %%F in (*) do (
@REM     set "path=%%~fF"
@REM     if "!path:~100!" neq "" (
@REM         echo !path!
@REM     )
@REM )

@REM echo "path length checker completed.."

@REM pause