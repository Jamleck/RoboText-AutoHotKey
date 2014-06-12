:: Unzip Files in to the Download Folder

@echo off

for /f "tokens=2-4 delims=/ " %%a in ('date /T') do set year=%%c
for /f "tokens=2-4 delims=/ " %%a in ('date /T') do set month=%%a
for /f "tokens=2-4 delims=/ " %%a in ('date /T') do set day=%%b
set datestr=%month%%day%%year%

SET UNZIPCOMMAND="%ProgramFiles%\7-Zip\7z.exe"
if not exist %UNZIPCOMMAND% SET UNZIPCOMMAND="%ProgramFiles(x86)%\7-Zip\7z.exe"

SET OUTPUT_FOLDER=C:\temp\archives
SET INPUT_FOLDER=%USERPROFILE%\Downloads
SET ARCHIVE=%INPUT_FOLDER%\UNZIPPED\Archive_%datestr%

if not exist %OUTPUT_FOLDER%\NUL mkdir %OUTPUT_FOLDER% 
if not exist %ARCHIVE%\NUL mkdir %ARCHIVE%

cd %INPUT_FOLDER%

if "%~1"=="" GOTO UNZIP_ALL_FILES

Echo Unzipping "%~1" to %OUTPUT_FOLDER%...

echo %UNZIPCOMMAND% x "%~1" -o%OUTPUT_FOLDER% -y

%UNZIPCOMMAND% x "%~1" -o%OUTPUT_FOLDER% -y > nul

move /y "%~1" "%ARCHIVE%"

GOTO:EOF

:UNZIP_ALL_FILES

REM forfiles /p %INPUT_FOLDER% /m *.zip /c "cmd /c if @isdir==FALSE echo @path"
forfiles /p %INPUT_FOLDER% /m *.zip /c "cmd /c if @isdir==FALSE %%UNZIPCOMMAND%% x @path -o%OUTPUT_FOLDER% -y && echo %OUTPUT_FOLDER%\@fname"

GOTO:EOF