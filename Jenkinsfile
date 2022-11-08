pipeline {
    agent any
    stages {
        stage('Build Execution Environement'){
            steps {
                sh 'chmod +x build.sh'
                sh './build.sh create-image'
            }
        }
        stage('Execution of testCases'){
            steps {
                sh './build.sh run'
            }
        }
        stage("Export Test Results"){
            steps{
               junit '**/target/surefire-reports/TEST-*.xml'
            }
        }  
    }
}


