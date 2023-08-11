@echo on
setlocal enabledelayedexpansion

REM %1 can be "noclean" to skip the maven clean phase
REM %2 can be "products" to just do the products directory

for %%i in ( mvn.cmd ) do set "M2_HOME=%%~dp$PATH:i.."

set "MY_ARGS=clean verify"
if /i "%1" == "noclean" (
    set "MY_ARGS=verify"
)

set "TOP=%~dp0"
set "SRC_DIR=%TOP%"

REM uncomment this to debug
REM set "MY_ARGS=%MY_ARGS% -e -X"

REM these are maven jvm options
set "MAVEN_OPTS=-Xmx4096m"

for /D %%I in ( "C:\Program Files\AdoptOpenJDK\jdk-11*" "C:\Program Files\Eclipse Adoptium\jdk-11*" ) do SET "JDKDIR=%%I"

if "%JDKDIR%" == "" (
	@echo "ERROR: Cannot find JDK 11 - please check/install"
	@echo Oracle Java will no longer be found/used - please install OpenJDK https://adoptopenjdk.net/releases.html#x64_win
	goto error
)

if not exist "%JDKDIR%\lib\javafx.base.jar" (
    @echo "JDK has not been patched to include javafx support, you will be unable to build"
    @echo "Follow instructions at https://github.com/ISISComputingGroup/ibex_developers_manual/wiki/Upgrade-Java#additional-optional-steps-for-developer-installations-not-required-on-instruments"
    goto error
)

set "JAVA_HOME=%JDKDIR%"

REM Build maven-osgi-bundles to ensure all bundles are available for Tycho resolution.
cd %TOP%cs-studio

if /i "%2" == "products" (
    call mvn %MY_ARGS% -f product/pom.xml -Dcsstudio.composite.repo=%TOP%cs-studio\p2repo -DskipTests=true -Dmaven.repo.local=%TOP%.m2\repository
    if !errorlevel! neq 0 goto error
) else (
    call mvn %MY_ARGS% -f maven-osgi-bundles/pom.xml -Dmaven.repo.local=%TOP%.m2\repository
    if !errorlevel! neq 0 goto error

    REM Build everything else.
    call mvn %MY_ARGS% -Dcsstudio.composite.repo=%TOP%cs-studio\p2repo -DskipTests=true -Dmaven.repo.local=%TOP%.m2\repository
    if !%errorlevel! neq 0 goto error
)

cd %TOP%

@echo Build successful.
GOTO :EOF

:ERROR
@echo Build failed.

exit /b 1
