@echo off

REM This batch script automates the release process for an application called "AA_Pro".

REM Get the path where the batch file is located.
cd /D "%~dp0"

REM Configure input and output folders.
set level1="%~dp0.."                 REM Parent directory of the batch file.
set level2="%level1%\.."             REM Grandparent directory of the batch file.
set RELEASE_DIR=%level2%\Auto_Release\AA_Pro  REM Directory where the release files will be stored.

set input=%level1%                    REM Input directory (where source files are located).
set output=%RELEASE_DIR%              REM Output directory (where release files will be stored).

echo The release will be built in this folder. Warning: If you proceed, it will overwrite possible existing files.
echo %output%

REM Create the release directory if it doesn't exist.
mkdir "%RELEASE_DIR%"

REM Set the file containing excluded files for copying.
set "excluded_files_file=Py_delete_excluded_files.txt"  REM File containing a list of files to exclude from copying.

REM Set the addon name.
set addon_name=AA_Pro               REM Name of the application.

REM Create the output directory for the final release files.
set OUTPUT_DIR=%level2%\Auto_Release\output\%addon_name%  REM Directory where the final release files will be stored.
mkdir "%OUTPUT_DIR%"
echo You will find the final output here: %OUTPUT_DIR%

REM This section is commented out, but it provides an example of how to exclude subfolders from the copy process using a file named "xcopy_exclude.txt".
@REM REM this gives the ability to exlude subfolders from the copy process
@REM @REM example in the xcopy_exclude.txt
@REM @REM subfolder2\
@REM @REM subfolder1\
@REM @REM subfolder2\
@REM xcopy "%input%\*" "%output%\" /s /e /exclude:xcopy_exclude.txt

REM Copy all files from the input folder to the release directory, excluding files specified in "xcopy_exclude.txt".
xcopy "%input%\*" "%RELEASE_DIR%\" /s /e /y /exclude:xcopy_exclude.txt  REM Copies all files and subfolders from the input directory to the release directory.

REM This section is commented out, but it provides an example of how to copy a specific file to the release directory.
@REM REM copy the Demo_file_download_link.txt to the autorelease folder.
@REM xcopy "%input%\Demo_file_download_link.txt" "%RELEASE_DIR%\..\" /s /e /y 

REM Delete a specific folder in the release directory if it exists.
set folderPath=%RELEASE_DIR%\Release_build_helper   REM Path to the folder to delete.
if exist "%folderPath%" (
    (echo. & echo Y) | rmdir /s /q "%folderPath%"  REM Deletes the folder and its contents.
    timeout /t 1 /nobreak >nul             REM Waits for 1 second.
    echo Folder: %folderPath% deleted successfully.
) else (
    echo Folder not found.
)

REM Copy the UI installer files to the output directory, but only if they don't already exist.
set venv_from_folder=%level1%\UI\installer_files  REM Source directory for the UI installer files.
set venv_to_folder=%OUTPUT_DIR%\UI\installer_files  REM Destination directory for the UI installer files.
IF NOT EXIST "%venv_to_folder%\*" (
    xcopy "%venv_from_folder%\*" "%venv_to_folder%\" /s /e  REM Copies the UI installer files to the output directory.
)

REM Create the binary files with the excluded files.
REM First, activate the miniconda venv.
@REM %~dp0: Breaks down as follows:
@REM %~d0: Extracts the drive letter from %0.
@REM %~p0: Extracts the path (directory) from %0.
@REM Combining the above two (%~d0 and %~p0) gives the drive and path of the batch file.

@REM REM this is getting the path where the bat file is.
@REM cd /D "%~dp0"

REM Get the parent path of the batch file.
cd /D "%~dp0.."

@rem Deactivate existing conda envs as needed to avoid conflicts.
(call conda deactivate && call conda deactivate && call conda deactivate) 2>nul  REM Deactivates any existing conda environments.

@rem Configure the conda environment.
set CONDA_ROOT_PREFIX=%cd%\dev_env\conda  REM Path to the conda root directory.
set INSTALL_ENV_DIR=%cd%\dev_env\env     REM Path to the conda environment directory.

@rem Activate the installer environment.
call "%CONDA_ROOT_PREFIX%\condabin\conda.bat" activate "%INSTALL_ENV_DIR%" || ( echo. && echo Miniconda hook not found. && goto end )  REM Activates the conda environment.

REM Change directory to the batch file location.
cd /D "%~dp0"

REM Before compiling, change some variables in the "__Init__.py" file using the "10_search_replace_string.py" script.
REM this will be modified in the release folder so the source folder (Input)
set called_script=%cd%\10_search_replace_string.py  REM Path to the script used to modify the "__Init__.py" file.
set file_to_modify=%RELEASE_DIR%\__Init__.py         REM Path to the "__Init__.py" file.
set old_string=Is_development:bool=True             REM String to be replaced.
set new_string=Is_development:bool=False            REM Replacement string.

call python %call_script% %file_to_modify% %old_string% %new_string%  REM Runs the script to modify the "__Init__.py" file.

REM Compile all Python files in the release directory to bytecode binaries.
call python -m compileall -b -f %RELEASE_DIR%   REM Compiles all Python files in the release directory to bytecode binaries.

REM Remove all Python files from the release directory, except those specified in "Py_delete_excluded_files.txt".
set "excluded_files_file=Py_delete_excluded_files.txt"  REM File containing a list of files to exclude from deletion.

for /R "%RELEASE_DIR%" %%f in (*.py) do (  REM Iterates through all Python files in the release directory.
    set "exclude_file="
    for /F "tokens=*" %%x in (%excluded_files_file%) do (  REM Iterates through the lines in the excluded files file.
        if /I "%%~nxf" == "%%~x" set "exclude_file=1"  REM Checks if the current file is listed in the excluded files file.
    )
    if not defined exclude_file (
        del "%%f"  REM Deletes the current file if it is not listed in the excluded files file.
    )
)

REM Copy the compiled files to the final output folder.
@REM xcopy "%RELEASE_DIR%\*" "%OUTPUT_DIR%\" /s /e /y /exclude:xcopy_exclude_final.txt
xcopy "%RELEASE_DIR%\*" "%OUTPUT_DIR%\" /s /e /y  REM Copies the compiled files from the release directory to the output directory.

REM Generate a zip file from the output folder.
set "path=%ProgramFiles%\7-Zip;%path%"  REM Adds the 7-Zip path to the system's PATH environment variable.

REM Set the full path of the zip file.
set zipFile_full_path=%OUTPUT_DIR%\..\..\%addon_name%.zip  REM Path to the zip file.

REM Delete any existing zip file with the same name.
if exist "%zipFile_full_path%" (
    del "%zipFile_full_path%"  REM Deletes the existing zip file.
    echo deleted %zipFile_full_path% successfully.
) else (
    echo Zip file to delete  not found.
)

REM Create the zip file using 7-Zip.
@REM rem Create a zip file from the Release folder to the zipFile_full_path
@REM call 7z a "%zipFile_full_path%" "%OUTPUT_DIR%\..\output\*"
call 7z a "%zipFile_full_path%" "%OUTPUT_DIR%\..\*"  REM Creates the zip file using 7-Zip.

echo All operations completed successfully.

pause


REM Some stuff
@REM cd /D "%~dp0.."
@REM set parent_output="%~dp0.."
@REM set grand_parent_output="%~dp0..\.."
@REM set level1="%~dp0.."
@REM set level2="%level1%\.."
@REM set level3="%level2%\.."
@REM set level4="%level3%\.."
@REM set level5="%level4%\.."
@REM xcopy "%input%\*" "%output%\" /s /e