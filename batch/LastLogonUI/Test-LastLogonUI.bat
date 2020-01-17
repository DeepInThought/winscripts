@echo off
setlocal EnableDelayedExpansion
setlocal EnableExtensions
cls

@REM TODO: Add a persistent location and cycle files after X amount of reboots.
set _reg_backup_loc=%TEMP%\LogonUI.reg
@REM If you want to bypass automatic message prompt, comment out Call:Messages below.
Call:Messages
set _chk_rootkey=HKEY_LOCAL_MACHINE
set _chk_subkey=\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\LogonUI
set _chk_keyname=!_chk_rootkey!!_chk_subkey!

:: Quick check if PowerShell colorization is plausible.
if exist "%temp%\color.psm1" (
    powershell -command "&{set-executionpolicy remotesigned; Import-Module '%temp%\color.psm1'}"
    del "%temp%\color.psm1"
)

::RegIntro - A Subroutine to display information on the data being extracted.
:RegIntro
Call:SetTab 1
Call :ColorText 0B "%TAB%=============================================="
Call :ColorText 06 "%TAB%KeyName = The full name of a registry key under the selected ROOTKEY." 
Call :ColorText 0A "%TAB%  +---ValueName = Registry Key Value"
Call :ColorText 0B "%TAB%%TAB%  +---ValueType = REG_SZ, REG_MULTI_SZ, REG_EXPAND_SZ, REG_DWORD, REG_QWORD, REG_BINARY, REG_NO"
Call :ColorText 0D "%TAB%%TAB%  +---ValueData = Specifies the registry keys actual data"
Call :ColorText 0B "%TAB%=============================================="
echo [Searching]: %_chk_keyname%

FOR /F "delims=" %%a in ('reg query %_chk_keyname%') DO (
  set _data_record=%%a
  call :ExtractRegKeys
)

echo [Exporting]: HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\LogonUI %_reg_backup_loc%
exit /b 0

::SetTab - A Subroutine to define a TAB variable for ease of usage.
:SetTab
Setlocal EnableDelayedExpansion
set "_CHAR="
set "_END=    "
FOR /L %%I IN (1,1,%1) DO set "_CHAR=!_CHAR!%_END%" 
(
  endlocal
  set "TAB=%_CHAR%"
  exit /b
)

::ExtractRegKeys - A Subroutine to parse through reg query by each record and field.
:ExtractRegKeys
Setlocal EnableDelayedExpansion
Setlocal EnableExtensions
set i=1
set _data_field=%_data_record:    = & set /A i+=1 & set _data_field!i!=%
set _keyname=%_data_field%
set _valuename=%_data_field2%
set _valuetype=%_data_field3%
set _valuedata=%_data_field4%

Call:SetTab 1
IF NOT ["%_keyname%"]==[""] ( 
  IF NOT ["%_valuename%"]==[""] (
  Call :ColorText 0A "%TAB%+---ValueName !_valuename!"
  ) ELSE (
    Call :ColorText 06 "+---KeyName!_data_field!"
    REM Call :ColorText 06 "[KeyName]" & echo(+[%_keyname%]
  )
  IF NOT ["%_valuetype%"]==[""] (
  Call :ColorText 0B "%TAB%%TAB%+---ValueType !_valuetype!
  )
  IF NOT ["%_valuedata%"]==[""] (
  Call :ColorText 0D "%TAB%%TAB%  +---ValueData %_valuedata%"
  ) 
)

exit /b

::Messages - A Subroutine to provide user with any necessary details about the functionality of the script.
:Messages
Call:SetTab 1
setlocal EnableDelayedExpansion
set github=https://github.com/DeepInThought/winscripts.git
set license=https://github.com/DeepInThought/winscripts/blob/master/LICENSE

@echo off
setlocal EnableDelayedExpansion
for /F "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do rem"') do (
  set "DEL=%%a"
)

Call :ColorText 0B "==============================================================================" /n
Call :ColorText 06 "Welcome to LastLogonUI.bat" /n
Call :ColorText 07 "A Windows batch script to revert who was the  " /n
Call :ColorText 07 "last user to login via the Windows LogonUI." /n
Call :ColorText 07 "Please read below for script usage." /n
Call :ColorText 0B "==============================================================================" /n

Call :ColorText 0b "%TAB%[INFO] The backup location defaults to the Windows temp directory" /n
Call :ColorText 0b "%TAB%which does not sustain reboots, so a persistent location is idea." /n
Call :ColorText 02 "%TAB%[OPTION] To remedy update the _reg_backup_loc variable at the top of the script." /n
Call :ColorText 0b "%TAB%[INFO] To disable automatic message prompts remove the Call Messages under the _reg_backup_loc" /n
Call :ColorText 0d "%TAB%[TODO] Add script switches to bypass certain functionality.  i.e. This automatic message." /n

Call :ColorText 0B "%TAB%==============================================================================" /n
Call :ColorText 06 "%TAB%Questions or issues visit the GitHub repository." /n & echo(  %TAB% %github% 
Call :ColorText 06 "%TAB%This script is licensed under the MIT License." /n & echo(  %TAB% %license%
Call :ColorText 0B "%TAB%==============================================================================" /n

SET /P msgPrompt="Press the ENTER key to begin script execution."


goto :EOF

::ColorText - Borrowed with Love from https://stackoverflow.com/questions/2048509/how-to-echo-with-different-colors-in-the-windows-command-line/23072489#23072489
REM :ColorText
REM @echo off
REM < set /p ".=%DEL%" > "%~2"
REM findstr /v /a:%1 /R "^$" "%~2" 
REM del "%~2" > nul 2>&1

::ColorTextNoNewLn - This subroutine mimics the original ColorText, minus the added newln.
:ColorTextNoNewLn
%newln%

::ColorTextNew - Borrowed with Love from https://stackoverflow.com/questions/2048509/how-to-echo-with-different-colors-in-the-windows-command-line/23072489#23072489
:: Source - See https://stackoverflow.com/questions/4339649/how-to-have-multiple-colors-in-a-windows-batch-file/5344911#5344911
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:ColorText <color pair> <string> </n>
setlocal enabledelayedexpansion
set "colors=0-black;1-darkblue;2-darkgreen;3-darkcyan;4-darkred;5-darkmagenta;6-darkyellow;7-gray;8-darkgray;9-blue;a-green;b-cyan;c-red;d-magenta;e-yellow;f-white"
set "p=%~1"
set "bg=!colors:*%p:~0,1%-=!"
set bg=%bg:;=&rem.%
set "fg=!colors:*%p:~-1%-=!"
set fg=%fg:;=&rem.%

if not "%~3"=="/n" set "br=-nonewline"
set "str=%~2" & set "str=!str:'=''!"

>>"%temp%\color.psm1" echo write-host '!str!' -foregroundcolor '%fg%' -backgroundcolor '%bg%' %br%
endlocal

goto :EOF