pipeline {
    agent {
        label 'testNode'
    }
    stages {
        stage('Build/Upload') {
            steps {
                sh './gradlew'
            }
        }
        stage('Run Terraform'){
            when {
                expression {
                    return env.BRANCH_NAME == ("master")
                }
            }
            steps{
                script {
                    withEnv(["PATH+terraform=${tool 'terraform'}",
                             "GRADLE_OPTS='-Dorg.gradle.daemon=false'"]) {
                        withCredentials([
                                string(credentialsId: 'Carter-Research-ID', variable: 'USER_ID'),
                                string(credentialsId: 'aws-role-deploy', variable: 'ROLE_NAME')
                        ])
                    }
                }
            }
        }
        stage()
    }
}
