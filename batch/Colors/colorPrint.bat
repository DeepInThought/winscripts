@echo off
setlocal disableDelayedExpansion
set q=^"
echo(
echo(
call :c 0E "                ,      .-;" /n
call :c 0E "             ,  |\    / /  __," /n
call :c 0E "             |\ '.`-.|  |.'.-'" /n
call :c 0E "              \`'-:  `; : /" /n
call :c 0E "               `-._'.  \'|" /n
call :c 0E "              ,_.-=` ` `  ~,_" /n
call :c 0E "               '--,.    "&call :c 0c ".-. "&call :c 0E ",=!q!." /n
call :c 0E "                 /     "&call :c 0c "{ "&call :c 0A "* "&call :c 0c ")"&call :c 0E "`"&call :c 06 ";-."&call :c 0E "}" /n
call :c 0E "                 |      "&call :c 0c "'-' "&call :c 06 "/__ |" /n
call :c 0E "                 /          "&call :c 06 "\_,\|" /n
call :c 0E "                 |          (" /n
call :c 0E "             "&call :c 0c "__ "&call :c 0E "/ '          \" /n
call :c 02 "     /\_    "&call :c 0c "/,'`"&call :c 0E "|     '   "&call :c 0c ".-~!q!~~-." /n
call :c 02 "     |`.\_ "&call :c 0c "|   "&call :c 0E "/  ' ,    "&call :c 0c "/        \" /n
call :c 02 "   _/  `, \"&call :c 0c "|  "&call :c 0E "; ,     . "&call :c 0c "|  ,  '  . |" /n
call :c 02 "   \   `,  "&call :c 0c "|  "&call :c 0E "|  ,  ,   "&call :c 0c "|  :  ;  : |" /n
call :c 02 "   _\  `,  "&call :c 0c "\  "&call :c 0E "|.     ,  "&call :c 0c "|  |  |  | |" /n
call :c 02 "   \`  `.   "&call :c 0c "\ "&call :c 0E "|   '     "&call :c 0A "|"&call :c 0c "\_|-'|_,'\|" /n
call :c 02 "   _\   `,   "&call :c 0A "`"&call :c 0E "\  '  . ' "&call :c 0A "| |  | |  |           "&call :c 02 "__" /n
call :c 02 "   \     `,   "&call :c 0E "| ,  '    "&call :c 0A "|_/'-|_\_/     "&call :c 02 "__ ,-;` /" /n
call :c 02 "    \    `,    "&call :c 0E "\ .  , ' .| | | | |   "&call :c 02 "_/' ` _=`|" /n
call :c 02 "     `\    `,   "&call :c 0E "\     ,  | | | | |"&call :c 02 "_/'   .=!q!  /" /n
call :c 02 "     \`     `,   "&call :c 0E "`\      \/|,| ;"&call :c 02 "/'   .=!q!    |" /n
call :c 02 "      \      `,    "&call :c 0E "`\' ,  | ; "&call :c 02 "/'    =!q!    _/" /n
call :c 02 "       `\     `,  "&call :c 05 ".-!q!!q!-. "&call :c 0E "': "&call :c 02 "/'    =!q!     /" /n
call :c 02 "    jgs _`\    ;"&call :c 05 "_{  '   ; "&call :c 02 "/'    =!q!      /" /n
call :c 02 "       _\`-/__"&call :c 05 ".~  `."&call :c 07 "8"&call :c 05 ".'.!q!`~-. "&call :c 02 "=!q!     _,/" /n
call :c 02 "    __\      "&call :c 05 "{   '-."&call :c 07 "|"&call :c 05 ".'.--~'`}"&call :c 02 "    _/" /n
call :c 02 "    \    .=!q!` "&call :c 05 "}.-~!q!'"&call :c 0D "u"&call :c 05 "'-. '-..'  "&call :c 02 "__/" /n
call :c 02 "   _/  .!q!    "&call :c 05 "{  -'.~('-._,.'"&call :c 02 "\_,/" /n
call :c 02 "  /  .!q!    _/'"&call :c 05 "`--; ;  `.  ;" /n
call :c 02 "   .=!q!  _/'      "&call :c 05 "`-..__,-'" /n
call :c 02 "    __/'" /n

if exist "%temp%\color.psm1" (
    powershell -command "&{set-executionpolicy remotesigned; Import-Module '%temp%\color.psm1'}"
    del "%temp%\color.psm1"
)

echo(

exit /b

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:c <color pair> <string> </n>
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