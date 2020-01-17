@echo off
setlocal EnableDelayedExpansion
setlocal EnableExtensions
cls

@REM TODO: Add a persistent location and cycle files after X amount of reboots.
set _reg_backup_loc=%TEMP%\LogonUI.reg
@REM If you want to bypass automatic message prompt, comment out Call:Messages below.
Call :Messages
set _chk_rootkey=HKEY_LOCAL_MACHINE
set _chk_subkey=\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\LogonUI
set _chk_keyname=!_chk_rootkey!!_chk_subkey!

goto :EOF

::**********************RegIntro Begin********************************
:: A Subroutine to display information on the data being extracted. ::
::********************************************************************
:RegIntro
Call :SetTab 1
Call :ColorTextNew 0B "==============================================" /n
Call :ColorTextNew 06 "KeyName = The full name of a registry key under the selected ROOTKEY." /n
Call :ColorTextNew 0A "  +---ValueName = Registry Key Value" /n
Call :ColorTextNew 0B "  +---ValueType = REG_SZ, REG_MULTI_SZ, REG_EXPAND_SZ, REG_DWORD, REG_QWORD, REG_BINARY, REG_NO" /n
Call :ColorTextNew 0D "  +---ValueData = Specifies the registry keys actual data" /n
Call :ColorTextNew 0B "==============================================" /n
Call :ColorTextNew 0B " " /n
Call :ColorTextNew 0B "[Searching]: " &call :ColorTextNew 0F "%_chk_keyname%" /n
Call :ColorTextNew 0B " " /n

FOR /F "delims=" %%a in ('reg query %_chk_keyname%') DO (
  set _data_record=%%a
  call :ExtractRegKeys

)

Call :ColorTextNew 0B " " /n
Call :ColorTextNew 0B "[Exporting]: " &call :ColorTextNew 0F "%_chk_keyname%" /n
Call :ColorTextNew 0B "To: " &call :ColorTextNew 0F "%_reg_backup_loc%" /n

REM echo  HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\LogonUI %_reg_backup_loc%

@REM Quick check if PowerShell colorization is plausible.
if exist "%temp%\color.psm1" (
    powershell -command "&{set-executionpolicy remotesigned; Import-Module '%temp%\color.psm1'}"
    del "%temp%\color.psm1"
) 

goto :EOF
::----------------------------RegIntro END----------------------------


::**********************SetTab Begin**************************
:: A Subroutine to define a TAB variable for ease of usage. ::
::************************************************************
:SetTab
Setlocal EnableDelayedExpansion
cls
set "_CHAR="
set "_END=    "
FOR /L %%I IN (1,1,%1) DO set "_CHAR=!_CHAR!%_END%" 
(
  endlocal
  set "TAB=%_CHAR%"
  exit /b
)
goto :EOF
::-------------------------SetTab END-------------------------

::**********************ExtractRegKeys Begin***************************
:: A Subroutine to parse through reg query by each record and field. ::
::*********************************************************************
:ExtractRegKeys
Setlocal EnableDelayedExpansion
Setlocal EnableExtensions
set i=1
set _data_field=%_data_record:    = & set /A i+=1 & set _data_field!i!=%
set _keyname=%_data_field%
set _valuename=%_data_field2%
set _valuetype=%_data_field3%
set _valuedata=%_data_field4%

Call :SetTab 1
IF NOT ["%_keyname%"]==[""] ( 
  IF NOT ["%_valuename%"]==[""] (
  Call :ColorTextNew 0A "%TAB%+---!_valuename!" /n
  REM Call :ColorTextNew 0A "%TAB%+---ValueName=" &call :ColorTextNew 8a "!_valuename!" /n
  ) ELSE (
    REM Call :ColorText 06 "+---KeyName!_data_field!"
    Call :ColorTextNew 0B " " /n
    Call :ColorTextNew 0B "[Found]: " /n
    Call :ColorTextNew 06 "!_keyname!" /n
  )
  IF NOT ["%_valuetype%"]==[""] (
  Call :ColorTextNew 0B "%TAB%%TAB%+---!_valuetype!" /n
  )
  IF NOT ["%_valuedata%"]==[""] (
  Call :ColorTextNew 0D "%TAB%%TAB%  +---!_valuedata!" /n
  ) 
)

goto :EOF
::-------------------------ExtractRegKeys END--------------------------

::**********************Messages Begin**************************************************************
:: A Subroutine to provide user with any necessary details about the functionality of the script. ::
::**************************************************************************************************
:Messages
Call:SetTab 1
setlocal EnableDelayedExpansion
set github=https://github.com/DeepInThought/winscripts.git
set license=https://github.com/DeepInThought/winscripts/blob/master/LICENSE

for /F "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do rem"') do (
  set "DEL=%%a"
)

color
Call :ColorTextNew 0B "%TAB%==============================================================================" /n
Call :ColorTextNew 06 "%TAB%Welcome to LastLogonUI.bat" /n
Call :ColorTextNew 07 "%TAB%A Windows batch script to revert who was the  " /n
Call :ColorTextNew 07 "%TAB%last user to login via the Windows LogonUI." /n
Call :ColorTextNew 07 "%TAB%Please read below for script usage." /n
Call :ColorTextNew 0B "%TAB%==============================================================================" /n
Call :ColorTextNew 0B " " /n
Call :ColorTextNew 0b "%TAB%[INFO] The backup location defaults to the Windows temp directory" /n
Call :ColorTextNew 0b "%TAB%which does not sustain reboots, so a persistent location is idea." /n
Call :ColorTextNew 0a "%TAB%[OPTION] To remedy update the _reg_backup_loc variable at the top of the script." /n
Call :ColorTextNew 0b "%TAB%[INFO] To disable automatic message prompts remove the Call Messages under the _reg_backup_loc" /n
Call :ColorTextNew 0d "%TAB%[TODO] Add script switches to bypass certain functionality.  i.e. This automatic message." /n
Call :ColorTextNew 0B " " /n
Call :ColorTextNew 0B "%TAB%==============================================================================" /n
Call :ColorTextNew 06 "%TAB%Questions or issues visit the GitHub repository." /n &call :ColorTextNew 07 "%TAB% %github%" /n
Call :ColorTextNew 06 "%TAB%This script is licensed under the MIT License." /n &call :ColorTextNew 07 "%TAB% %license%" /n
Call :ColorTextNew 0B "%TAB%==============================================================================" /n
Call :ColorTextNew 0B " " /n

@REM Quick check if PowerShell colorization is plausible.
if exist "%temp%\color.psm1" (
    powershell -command "&{set-executionpolicy remotesigned; Import-Module '%temp%\color.psm1'}"
    del "%temp%\color.psm1"
) 

:MessageChoice
set /P c=Are you sure you want to continue[Y/N]?
if /I "%c%" EQU "Y" goto :RegIntro
if /I "%c%" EQU "N" goto :EOF
goto :MessageChoice

endlocal
goto :EOF

::-------------------------------------------Messages END-------------------------------------------

:ColorTextNew <color pair> <string> </n>
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
