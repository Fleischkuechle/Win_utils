@echo off


cd /D "%~dp0"

set PATH=%PATH%;%SystemRoot%\system32

echo "%CD%"| findstr /C:" " >nul && echo This script relies on Miniconda which can not be silently installed under a path with spaces. && goto end

@rem fix failed install when installing to a separate drive
set TMP=%cd%\installer_files
set TEMP=%cd%\installer_files

@rem deactivate existing conda envs as needed to avoid conflicts
(call conda deactivate && call conda deactivate && call conda deactivate) 2>nul

@rem config
set CONDA_ROOT_PREFIX=%cd%\installer_files\conda
set INSTALL_ENV_DIR=%cd%\installer_files\env

@rem environment isolation
set PYTHONNOUSERSITE=1
set PYTHONPATH=
set PYTHONHOME=
set "CUDA_PATH=%INSTALL_ENV_DIR%"
set "CUDA_HOME=%CUDA_PATH%"

@rem activate installer env
call "%CONDA_ROOT_PREFIX%\condabin\conda.bat" activate "%INSTALL_ENV_DIR%" || ( echo. && echo Miniconda hook not found. && goto end )
REM For more info how pyinstaller works: https://pyinstaller.org/en/v3.6/usage.html

REM  you must use conda install pyinstaller if you working with miniconda dont do pip install pyinstaller because that wont stay in the conda env.
REM found on https://stackoverflow.com/questions/51494470/python-executable-by-pyinstaller-in-virtual-conda-environment-dll-load-failed

REM first compile the python files to binarys call python -m py_compile File1.py File2.py File3.py ...
REM to compile all python files in a folder call python -m compileall .   while . is the folder could also be .\BackendCoreClassLib\InBlenderRunningLib
REM call python -m compileall .\BackendCoreClassLib\InBlenderRunningLib
REM if you have problems try python -m compileall -b  .      this should create the files inside the folde not in the __pycache__ folder.
REM call python -m compileall -b BackendCoreClassLib\InBlenderRunningLib
REM call python -m compileall -b -f  BackendCoreClassLib\InBlenderRunningLib     the -f forces to recompile even there was no change in the file
call python -m compileall -b -f BackendCoreClassLib\InBlenderRunningLib
REM "FrontEndUI\Icon\Nerd123Logo_ohneBackground.ico"
REM --add-data="FrontEndUI\Icon\Nerd123Logo_ohneBackground.ico;FrontEndUI\Icon" ^
REM "BackendCoreClassLib\BlendFile\Demo_With_Astra_From_Mixamo.blend"
REM --icon= "FrontEndUI\Icon\Nerd123Logo_ohneBackground.ico" ^
REM --add-data="FrontEndUI\Icon\Nerd123Logo_ohneBackground.png;FrontEndUI\Icon" ^
REM Hidden imports (important for mediapipe solutions) because of this error    File "mediapipe\python\solution_base.py", line 264, in __init__ FileNotFoundError: The path does not exist.
REM -—hidden-import="mediapipe" ^
REM D:\07\08\new_umocap\installer_files\env\Lib\site-packages\mediapipe
REM --add-data= "C:\Users\USER\AppData\Local\Programs\Python\Python310\Lib\site-packages\mediapipe;mediapipe/"
REM --add-data="installer_files\env\Lib\site-packages\mediapipe;mediapipe/" ^

REM Now we need the already existing armature and mocaprig maps to be copied over to the exe build
REM --add-data="BackendCoreClassLib\InBlenderRunningLib\*.json;BackendCoreClassLib\InBlenderRunningLib" ^



REM run pyinstaller
call pyinstaller  ^
--add-data="installer_files\env\Lib\site-packages\mediapipe;mediapipe/" ^
--icon="FrontEndUI\Icon\Nerd123Logo_ohneBackground.ico" ^
--add-data="BackendCoreClassLib\SettingFiles\AppData.json;BackendCoreClassLib\SettingFiles" ^
--add-data="BackendCoreClassLib\SettingFiles\UmocapSettings.json;BackendCoreClassLib\SettingFiles" ^
--add-data="BackendCoreClassLib\InBlenderRunningLib\MoResive004.py;BackendCoreClassLib\InBlenderRunningLib" ^
--add-data="BackendCoreClassLib\InBlenderRunningLib\*.pyc;BackendCoreClassLib\InBlenderRunningLib" ^
--add-data="BackendCoreClassLib\InBlenderRunningLib\*.json;BackendCoreClassLib\InBlenderRunningLib" ^
--add-data="BackendCoreClassLib\BlendFile\Demo_With_Astra_From_Mixamo.blend;BackendCoreClassLib\BlendFile" ^
--add-data="FrontEndUI\Icon\Nerd123Logo_ohneBackground.ico;FrontEndUI\Icon" ^
--add-data="FrontEndUI\Icon\Nerd123Logo_ohneBackground.png;FrontEndUI\Icon" ^
--console ^
MainApp.py
@rem enter commands
cmd /k "%*"

:end
pause


