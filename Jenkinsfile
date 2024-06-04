pipeline {
    agent any

    tools {
        maven 'Maven3'  // Ensure Maven is installed and configured in Jenkins
    }

    environment {
        JAVA_HOME = '/Users/mahajokhio/.sdkman/candidates/java/19.0.2-open' // Set the correct path to your Java 19 installation
        PATH = "${JAVA_HOME}/bin:/usr/local/bin:${env.PATH}"
        SONAR_HOST_URL = 'https://sonarcloud.io'
        SONAR_ORGANIZATION = 'mahajokhio2'
        SONAR_PROJECT_KEY = 'mahajokhio2_spring-petclinic'
        DOCKER_PATH = "/usr/local/bin"
        DOCKER_IMAGE = 'mahajokhio2/spring-petclinic'
    }

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

        stage('SonarCloud Analysis') {
            steps {
                withSonarQubeEnv('SonarCloud') {
                    sh 'mvn sonar:sonar -Dsonar.projectKey=${SONAR_PROJECT_KEY} -Dsonar.organization=${SONAR_ORGANIZATION} -Dsonar.host.url=${SONAR_HOST_URL} -Dsonar.login=$SONAR_TOKEN'
                }
            }
        }

        stage('Deploy to Staging') {
            steps {
                script {
                    def image = docker.build("${DOCKER_IMAGE}")
                    image.run('-d -p 8080:8080')
                }
            }
        }

        stage('Release to Production') {
            steps {
                script {
                    docker.withRegistry('', 'dockerhub-credentials') {
                        def image = docker.build("${DOCKER_IMAGE}")
                        image.tag('latest')
                        image.push('latest')
                        image.push("${env.BUILD_ID}")
                    }
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

