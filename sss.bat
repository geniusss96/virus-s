@echo off
:Checkloop
Call :GetIP
Call :CheckIP
rem goto:checkloop
::******************************************************************************
:GetIP
set "IPLog=%userprofile%\Desktop\%~n0.txt"
Set "MyCommand=nslookup myip.opendns.com resolver1.opendns.com 2^>nul"
for /f "skip=4 delims=: tokens=2" %%a in ('%MyCommand%') Do (
    Set "MyExtIP=%%a"
)
Call :Trim %MyExtIP%
echo My Extenal IP Adress is : "%MyExtIP%"
echo %MyExtIP% > "%IPLog%"
Exit /b
::*************************************************************************************
:CheckIP
If Not Exist "%IPLog%" Call :GetIP
rem Set /p CheckIP=<%IPLog%
for /f "delims= " %%g in ('Type "%IPLog%"') do ( set "CheckIP=%%g")
rem echo "%CheckIP%" from file & pause
If "%CheckIP%"=="%MyExtIP%" ( Cls & color 0A & echo the IP Adress = %CheckIP% does not changed
) else (
    Cls & Color 0C & echo The IP Adress is changed to %MyExtIP%
)
Timeout /T 30 /Nobreak
goto:checkloop
::*************************************************************************************
:Trim <String>
set "vbsfile=%tmp%\%~n0.vbs"
(
    echo Wscript.echo Trim("%~1"^)
)>"%vbsfile%"
for /f "delims=" %%a in ('Cscript /nologo "%vbsfile%"') do ( set "MyExtIP=%%a" )
If Exist "%vbsfile%" Del "%vbsfile%"
exit /b
::*************************************************************************************