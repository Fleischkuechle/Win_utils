@echo off

@REM %~dp0: Breaks down as follows:
@REM %~d0: Extracts the drive letter from %0.
@REM %~p0: Extracts the path (directory) from %0.
@REM Combining the above two (%~d0 and %~p0) gives the drive and path of the batch file.

REM this is getting the path where the bat file is.
cd /D "%~dp0"

@REM REM this is getting the parent path fro where the bat file is.
@REM cd /D "%~dp0.."

set PATH=%PATH%;%SystemRoot%\system32

echo "%CD%"| findstr /C:" " >nul && echo This script relies on Miniconda which can not be silently installed under a path with spaces. && goto end

@rem fix failed install when installing to a separate drive
set TMP=%cd%\dev_env
set TEMP=%cd%\dev_env

@rem deactivate existing conda envs as needed to avoid conflicts
(call conda deactivate && call conda deactivate && call conda deactivate) 2>nul

@rem config
set CONDA_ROOT_PREFIX=%cd%\dev_env\conda
set INSTALL_ENV_DIR=%cd%\dev_env\env

@rem environment isolation
set PYTHONNOUSERSITE=1
set PYTHONPATH=
set PYTHONHOME=
set "CUDA_PATH=%INSTALL_ENV_DIR%"
set "CUDA_HOME=%CUDA_PATH%"

@rem activate installer env
call "%CONDA_ROOT_PREFIX%\condabin\conda.bat" activate "%INSTALL_ENV_DIR%" || ( echo. && echo Miniconda hook not found. && goto end )

REM here we run the script that does the work
@REM python 10_Double_Click_Me_To_Search_Replace_a_string_in_a_Py_file.py file_to_modify.py old_string new_string
REM python replace_string.py file_to_modify.py old_string new_string

@REM set called_script=replace_string.py
@REM set arg1=file_to_modify.py
@REM set arg2=old_string
@REM set arg3=new_string

set called_script=10_search_replace_string.py
set file_to_modify=10_Search_Replace_test.py
set old_string=Is_development:bool=True
set new_string=Is_development:bool=False

call python %called_script%  %file_to_modify%   %old_string%  %new_string%

@REM echo searched %old_string%   in  %file_to_modify%   and replaced it with %new_string%


@REM @rem enter commands
@REM cmd /k "%*"

:end
pause