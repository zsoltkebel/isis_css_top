#!groovy

pipeline {

  // agent defines where the pipeline will run.
  agent {  
    label "ndw1757"
  }
  
  triggers {
    cron('H 1 * * *')
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
        script {
            // env.BRANCH_NAME is only supplied to multi-branch pipeline jobs
            if (env.BRANCH_NAME == null) {
                env.BRANCH_NAME = ""
			}
			
        }
        
        bat """
            build.bat
            """
      }
    }
    
  }
  
  post {
    failure {
      step([$class: 'Mailer', notifyEveryUnstableBuild: true, recipients: 'icp-buildserver@lists.isis.rl.ac.uk', sendToIndividuals: true])
    }
  }
  
  // The options directive is for configuration that applies to the whole job.
  options {
    buildDiscarder(logRotator(numToKeepStr:'10'))
    timeout(time: 180, unit: 'MINUTES')
    disableConcurrentBuilds()
  }
}
