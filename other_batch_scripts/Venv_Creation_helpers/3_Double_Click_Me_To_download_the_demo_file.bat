@echo off

@REM samll info how to create the requirements.txt  (inside the python environment)
@REM pip freeze > requirements.txt

@REM REM this is getting the path where the bat file is.
@REM cd /D "%~dp0"

REM this is getting the parent path fro where the bat file is.
cd /D "%~dp0.."

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

@REM #cd into the folder where the  reqirement_installer.py is saved
cd /D "%~dp0"
@rem run download script
echo running download_demo_file.py  inside the conda virtual environment this may take some time.
call python download_demo_file.py %*

@rem enter commands
cmd /k "%*"

:end
pause
