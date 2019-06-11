set "M2_HOME=C:\apache-maven-3.5.0-bin\apache-maven-3.5.0"

set "TOP=%~dp0%"
set "SRC_DIR=%TOP%"
set "MAVEN_OPTS=-Xmx4096m"
set "OPTS=-s \"%TOP%\org.csstudio.sns\build\settings.xml\" clean verify"

cd %TOP%\diirt
mvn %OPTS%

cd %TOP%\maven-osgi-bundles
mvn %OPTS%

cd %TOP%\cs-studio-thirdparty
mvn %OPTS%

cd %TOP%\cs-studio\core
mvn %OPTS%

cd %TOP%\cs-studio\applications
mvn %OPTS%

set "CSS_REPO=%TOP%\org.csstudio.sns\css_repo\"
cd %TOP%\org.csstudio.display.builder
mvn %OPTS%

cd %TOP%\org.csstudio.sns
mvn %OPTS%

cd %TOP%
