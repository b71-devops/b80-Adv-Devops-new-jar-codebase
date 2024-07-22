pipeline {
    agent {
        node {
            label 'maven'
        }
    }

environment {
    PATH = "/opt/apache-maven-3.9.8/bin:$PATH"
}

    stages {
        stage("CODE-CLEANUP") {
            steps {
                sh 'mvn clean'
            }
        }
        stage("CODE-Integration-TEST") {
            steps {
                sh 'mvn surefire-report:report'
            }
        } 
        stage("CODE-BUILD") {
            steps {
                sh 'mvn install'
            }
        }  
        stage("SONARQUBE-ANALYSIS") {
            environment {
                scannerHome = tool 'b80-sonarqube-scanner'
            }
            steps {
                withSonarQubeEnv('sonarqube-cloud-server') {
                    sh "${scannerHome}/bin/sonar-scanner"
                }
            }
        }                       
    }
}
