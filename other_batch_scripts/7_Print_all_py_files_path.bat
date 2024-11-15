

@echo off
setlocal enabledelayedexpansion

REM Get the directory path where the batch file is located
set batch_path=%~dp0

REM Loop through each subfolder and get its size
for /R %batch_path% %%f in (*.py) do (
        echo %%f
    
)
pause
