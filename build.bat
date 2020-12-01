@echo on

set "M2_HOME=C:\apache-maven-3.5.0-bin\apache-maven-3.5.0"

set "TOP=%~dp0%"
set "SRC_DIR=%TOP%"
set "MAVEN_OPTS=-Xmx4096m"
set "OPTS=-s \"%TOP%\org.csstudio.sns\build\settings.xml\" clean verify"

for /D %%I in ( "C:\Program Files\AdoptOpenJDK\jdk-11*" ) do SET "JDKDIR=%%I"

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
cd %TOP%\cs-studio

call mvn -f maven-osgi-bundles/pom.xml clean verify
if %errorlevel% neq 0 goto error

REM Build everything else.
call mvn clean verify -Dcsstudio.composite.repo=%TOP%\cs-studio\p2repo -DskipTests=true
if %errorlevel% neq 0 goto error

cd %TOP%

@echo "Build successful."
GOTO :EOF

:ERROR
@echo "Build failed."
