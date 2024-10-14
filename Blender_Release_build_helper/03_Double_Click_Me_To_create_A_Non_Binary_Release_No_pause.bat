@echo off

@REM this is getting the path where the bat file is.
cd /D "%~dp0"
@REM config input and output folder (must be there)
set level1="%~dp0.."
set level2="%level1%\.."
set release_parent_folder_name="Auto_Release"
set addon_name=AA_Pro
set RELEASE_DIR=%level2%\%release_parent_folder_name%\%addon_name%

set input=%level1%
set output=%RELEASE_DIR%

echo the release will be build in this folder.. Warning if you proceed it will Overwrite possible existing files.
echo %output%

mkdir "%RELEASE_DIR%"
set "excluded_files_file=Py_delete_excluded_files.txt"
@REM Create the output folder
set OUTPUT_DIR=%level2%\%release_parent_folder_name%\output\%addon_name%
mkdir "%OUTPUT_DIR%"
echo here you will find the final output  %OUTPUT_DIR%


@REM @REM this gives the ability to exlude subfolders from the copy process
@REM @REM example in the xcopy_exclude.txt
@REM @REM subfolder2\
@REM @REM subfolder1\
@REM @REM subfolder2\
@REM xcopy "%input%\*" "%output%\" /s /e /exclude:xcopy_exclude.txt
echo Start to copy all files from Folder  %input% to the this Folder %RELEASE_DIR%
xcopy "%input%\*" "%RELEASE_DIR%\" /s /e /y /exclude:xcopy_exclude.txt
@REM @REM copy the Demo_file_download_link.txt to the autorelease folder.
@REM xcopy "%input%\Demo_file_download_link.txt" "%RELEASE_DIR%\..\" /s /e /y 

@REM deleting a folder in the release directory 
set release_builder_folder_path=%RELEASE_DIR%\Release_build_helper

if exist "%release_builder_folder_path%" (
    (echo. & echo Y) | rmdir /s /q "%release_builder_folder_path%"
    timeout /t 1 /nobreak >nul
    echo Folder: %release_builder_folder_path% deleted successfully.
) else (
    echo release_builder_folder_path not found. so its not deleted.
)

@REM Make sure the venv for the ui is copied only one time if it not exist
set venv_from_folder=%level1%\UI\installer_files
set venv_to_folder=%OUTPUT_DIR%\UI\installer_files
IF NOT EXIST "%venv_to_folder%\*" (
    @REM xcopy "%venv_from_folder%\*" "%venv_to_folder%\" /s /e 
    xcopy "%venv_from_folder%\*" "%venv_to_folder%\" /s /e /exclude:xcopy_VENV_exclude.txt
    echo copied virtual environment from:  %venv_to_folder%  to %venv_from_folder%
) else (
    echo venv not copied because venv folder already exist %venv_to_folder%.
)


@REM now create the binary files with the exclude ones
@REM first activate the miniconda venv
@REM %~dp0: Breaks down as follows:
@REM %~d0: Extracts the drive letter from %0.
@REM %~p0: Extracts the path (directory) from %0.
@REM Combining the above two (%~d0 and %~p0) gives the drive and path of the batch file.

@REM @REM this is getting the path where the bat file is.
@REM cd /D "%~dp0"

@REM this is getting the parent path fro where the bat file is.
echo next will do cd.. to here "%~dp0.."

cd /D "%~dp0.."

@REM deactivate existing conda envs as needed to avoid conflicts
(call conda deactivate && call conda deactivate && call conda deactivate) 2>nul

@REM config
set CONDA_ROOT_PREFIX=%cd%\dev_env\conda
set INSTALL_ENV_DIR=%cd%\dev_env\env
echo now i want to call %CONDA_ROOT_PREFIX%\condabin\conda.bat activate %INSTALL_ENV_DIR%

@REM activate virtual Conda env
call "%CONDA_ROOT_PREFIX%\condabin\conda.bat" activate "%INSTALL_ENV_DIR%" || ( echo. && echo Miniconda hook at %CONDA_ROOT_PREFIX%\condabin\conda.bat not found. && goto end )
@REM CD into the correct folder 
cd /D "%~dp0"
@REM before we compile we need to change some variables in the script init set Is_development to false
@REM using 10_search_replace_string.py which will be ran in the venv
echo setting  init.py  Is_development bool False  by using 10_search_replace_string.py
set called_script=%cd%\10_search_replace_string.py
set file_to_modify=%RELEASE_DIR%\__Init__.py
set old_string=Is_development:bool=True
set new_string=Is_development:bool=False
call python %called_script%  %file_to_modify%   %old_string%  %new_string%
set file_to_modify=%RELEASE_DIR%\Settings\My_aa_pro_Settings_Processor.py
call python %called_script%  %file_to_modify%   %old_string%  %new_string%

echo skipped binary file generation because its a non binary release.


REM Now the files are prepared we need to copy the files to the
REM final output folder
@REM xcopy "%RELEASE_DIR%\*" "%OUTPUT_DIR%\" /s /e /y /exclude:xcopy_exclude_final.txt
echo Preparing Zip Data Copy all files from  %RELEASE_DIR% to the this Folder %OUTPUT_DIR%.

xcopy "%RELEASE_DIR%\*" "%OUTPUT_DIR%\" /s /e /y 


@REM  Now i want to generate a zip file from that 
set "path=%ProgramFiles%\7-Zip;%path%"

@REM set output=%cd%\output
set zipFile_full_path=%OUTPUT_DIR%\..\..\%addon_name%.zip

@REM first delete a potential existing zip file
@REM set /p zipFilePath="Enter the full path of the zip file you want to delete: "
if exist "%zipFile_full_path%" (
    del "%zipFile_full_path%"
    echo deleted %zipFile_full_path% successfully.
) else (
    echo Zip file to delete  not found. 
)


@REM rem Create a zip file from the Release folder to the zipFile_full_path
@REM call 7z a "%zipFile_full_path%" "%OUTPUT_DIR%\..\output\*"
echo Creating a new ZIP file here  %zipFile_full_path% .
call 7z a "%zipFile_full_path%" "%OUTPUT_DIR%\..\*"


echo All operations completed successfully.

:end
pause