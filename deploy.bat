@echo on
setlocal enabledelayedexpansion

REM %1 is branch name
set "BRANCH=%1"

set "TOP=%~dp0"
set "PROD_DIR=%TOP%cs-studio\product\repository\target\products"
if "%BRANCH%" == "" (
    set "SUBDIR=BUILD-%BUILD_NUMBER%"
) else (
    set "SUBDIR=branches\%BRANCH%\BUILD-%BUILD_NUMBER%"
)
robocopy "%PROD_DIR%" "\\isis.cclrc.ac.uk\inst$\Kits$\CompGroup\ICP\CSStudio\%SUBDIR%" "*.zip" -PURGE -MT -NP -R:1
if !errorlevel! geq 4 (
	@echo ERROR: deploy zip
	exit /b 1
)
robocopy "%TOP%\jre" "\\isis.cclrc.ac.uk\inst$\Kits$\CompGroup\ICP\CSStudio\%SUBDIR%\jre" "*.*" -MIR -MT -NFL -NDL -NP -R:1 -LOG:NUL
if !errorlevel! geq 4 (
	@echo ERROR: deploy jre
	exit /b 1
)

exit /b 0
