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
        stage("CODE-TEST") {
            steps {
                sh 'mvn test'
            }
        } 
        stage("CODE-BUILD") {
            steps {
                sh 'mvn install'
            }
        }                
    }
}
