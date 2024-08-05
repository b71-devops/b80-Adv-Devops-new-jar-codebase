def registry = 'https://b80AdvancedDevops.jfrog.io'
def imageName = 'https://b80advanceddevops.jfrog.io/artifactory/b80-docker-local/b80-image'
def version = '2.1.2'

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
        stage("BUILD") {
            steps {
                sh 'mvn clean deploy -Dmaven.test.skip=true'
            }
        }
        stage("TEST") {
            steps {
                sh 'mvn surefire-report:report'
            }
        } 
        stage("Sonar-Analysis") {
            environment {
                scannerHome = tool 'b80-sonarqube-scanner'
            }
            steps {
                withSonarQubeEnv('sonarqube-cloud-server') {
                    sh "${scannerHome}/bin/sonar-scanner"
                }
            }
        }
        stage("Quality Gate") {
            steps {
                script {
                    timeout(time: 1, unit: 'HOURS') {
                        def qg = waitForQualityGate()
                        if (qg.status != 'OK') {
                            error "Pipeline aborted due to quality gate failure: ${qg.status}"
                        }
                    }
                }
            }
        }
        stage("JAR Publish") {
            steps {
                script {
                    echo '--------JAR Publish Started--------'
                     def server = Artifactory.newServer url:registry+"/artifactory" ,  credentialsId:"b80-jfog-jenkins-token"
                     def properties = "buildid=${env.BUILD_ID},commitid=${GIT_COMMIT}";
                     def uploadSpec = """{
                          "files": [
                            {
                              "pattern": "jarstaging/(*)",
                              "target": "b80-maven-jfrog-repo-libs-release-local/{1}",
                              "flat": "false",
                              "props" : "${properties}",
                              "exclusions": [ "*.sha1", "*.md5"]
                            }
                         ]
                     }"""
                     def buildInfo = server.upload(uploadSpec)
                     buildInfo.env.collect()
                     server.publishBuildInfo(buildInfo)
                     echo '--------JAR Publish Completed--------'  

                }
            }
        }                      
    }
    stage("Docker-BUILD") {
        steps {
            script {
                echo '***docker build started***'
                app = docker.build(imageName+":"+version)
                echo '***docker versioned image built***'
            }
        }
    }
}