@echo on
setlocal enabledelayedexpansion

REM %1 is branch name
set "BRANCH=%1"

set "TOP=%~dp0"
set "PROD_DIR=%TOP%cs-studio\repository\target\products"

if "%BRANCH%" == "" (
    robocopy "%PROD_DIR%" "\\isis.cclrc.ac.uk\inst$\Kits$\CompGroup\ICP\CSStudio\BUILD-%BUILD_NUMBER%" "*.zip" -MIR -MT -NP -R:1 
) else (
    robocopy "%PROD_DIR%" "\\isis.cclrc.ac.uk\inst$\Kits$\CompGroup\ICP\CSStudio\branches\%BRANCH%\BUILD-%BUILD_NUMBER%" "*.zip" -MIR -MT -NP -R:1 
) 
if !errorlevel! geq 4 (
	@echo ERROR: deploy
	exit /b 1
)
exit /b 0
