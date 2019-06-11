@echo on

set "M2_HOME=C:\apache-maven-3.5.0-bin\apache-maven-3.5.0"

set "TOP=%~dp0%"
set "SRC_DIR=%TOP%"
set "MAVEN_OPTS=-Xmx4096m"
set "OPTS=-s \"%TOP%\org.csstudio.sns\build\settings.xml\" clean verify"

for /D %%I in ( "C:\Program Files\AdoptOpenJDK\jdk-8*" ) do SET "JDKDIR=%%I"

if "%JDKDIR%" == "" (
	@echo "ERROR: Cannot find JDK 8 - please check/install"
	@echo Oracle Java will no longer be found/used - please install OpenJDK https://adoptopenjdk.net/releases.html#x64_win
	goto error
)

if not exist "%JDKDIR%\jre\lib\ext\jfxrt.jar" (
    @echo "JDK has not been patched to include javafx support, you will be unable to build"
	@echo "Follow instructions at https://github.com/ISISComputingGroup/ibex_developers_manual/wiki/Upgrade-Java#additional-optional-steps-for-developer-installations-not-required-on-instruments"
	goto error
)

set "JAVA_HOME=%JDKDIR%"

cd %TOP%\diirt
call mvn %OPTS%
if %errorlevel% neq 0 goto error

cd %TOP%\maven-osgi-bundles
call mvn %OPTS%
if %errorlevel% neq 0 goto error

cd %TOP%\cs-studio-thirdparty
call mvn %OPTS%
if %errorlevel% neq 0 goto error

cd %TOP%\cs-studio\core
call mvn %OPTS%
if %errorlevel% neq 0 goto error

cd %TOP%\cs-studio\applications
call mvn %OPTS%
if %errorlevel% neq 0 goto error

cd %TOP%\org.csstudio.display.builder
REM display builder needs an extra env variable setting for where to find the css repo.
call mvn -Dcss_repo="file:%TOP%\org.csstudio.sns\css_repo\" %OPTS%
if %errorlevel% neq 0 goto error

cd %TOP%\org.csstudio.sns
call mvn %OPTS%
if %errorlevel% neq 0 goto error

cd %TOP%

@echo "Build successful."
GOTO :EOF

:ERROR
@echo "Build failed."
