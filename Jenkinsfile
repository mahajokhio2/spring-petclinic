pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                git url: 'https://github.com/mahajokhio2/spring-petclinic.git', branch: 'main'
            }
        }

        stage('Build') {
            steps {
                sh './mvnw clean package'
            }
        }

        stage('Test') {
            steps {
                sh './mvnw test'
            }
        }

        stage('Code Quality Analysis') {
            steps {
                script {
                    def scannerHome = tool 'SonarQubeScanner'
                    withSonarQubeEnv('SonarQube') {
                        sh "${scannerHome}/bin/sonar-scanner"
                    }
                }
            }
        }

        stage('Deploy to Staging') {
            steps {
                script {
                    docker.build('spring-petclinic').run('-d -p 8080:8080')
                }
            }
        }

        stage('Release to Production') {
            steps {
                script {
                    docker.build('spring-petclinic').push('mahajokhio2/spring-petclinic:latest')
                }
            }
        }

        stage('Monitoring and Alerting') {
            steps {
                script {
                    withCredentials([string(credentialsId: 'newrelic-api-key', variable: 'NEWRELIC_API_KEY')]) {
                        sh '''
                        curl -X POST "https://api.newrelic.com/v2/applications.json" \
                        -H "X-Api-Key:${NEWRELIC_API_KEY}" -i \
                        -d "deployment[app_name]=spring-petclinic" \
                        -d "deployment[description]=Deployment via Jenkins" \
                        -d "deployment[revision]=${GIT_COMMIT}"
                        '''
                    }
                }
            }
        }
    }
}

