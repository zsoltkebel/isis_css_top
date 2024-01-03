#!groovy

pipeline {

  // agent defines where the pipeline will run.
  agent {  
    label "ndw1757"
  }
  
  triggers {
    cron('H 1 * * *')
  }
  
  environment {
      NODE = "${env.NODE_NAME}"
      ELOCK = "csstudio_${NODE}"
  }
  
  stages {  
    stage("Checkout") {
      steps {
        echo "Branch: ${env.BRANCH_NAME}"
        checkout scm
      }
    }
    
    stage("Build") {
      steps {
	    lock(resource: ELOCK, inversePrecedence: false) {
          script {
            // env.BRANCH_NAME is only supplied to multi-branch pipeline jobs
            if (env.BRANCH_NAME == null) {
                env.BRANCH_NAME = ""
			}			
          }
        
          bat """
            call build.bat
			if %errorlevel% neq 0 exit /b %errorlevel%
            """
        }
		
		
	  }
    }
	
	stage("Deploy") {
      steps {
          bat """
			call deploy.bat ${env.BRANCH_NAME}
			if %errorlevel% neq 0 exit /b %errorlevel%
            """
		}
	}
 
  }
   post { 
      cleanup {
          bat """
                  @echo Jenkins Cleanup step complete
                  @echo ***
                  @echo *** Any Office365connector Matched status FAILURE message below means
                  @echo *** an earlier Jenkins step failed not the Office365connector itself
                  @echo *** Search log file for  ERROR: and  ERROR  to locate true cause
                  @echo ***
                  exit /b 0
          """
        }
      always {
        logParser ([
            projectRulePath: 'parse_rules',
            parsingRulesPath: '',
            showGraphs: true, 
            unstableOnWarning: true,
            useProjectRule: true,
        ])
      }
	}
		
  // The options directive is for configuration that applies to the whole job.
  options {
    buildDiscarder(logRotator(numToKeepStr:'10'))
    timeout(time: 600, unit: 'MINUTES')
    disableConcurrentBuilds()
	timestamps()
	office365ConnectorWebhooks([[
                    name: "Office 365",
                    notifyBackToNormal: true,
                    startNotification: false,
                    notifyFailure: true,
                    notifySuccess: false,
                    notifyNotBuilt: false,
                    notifyAborted: false,
                    notifyRepeatedFailure: true,
                    notifyUnstable: true,
                    url: "${env.MSTEAMS_URL}"
            ]])
  }
}
