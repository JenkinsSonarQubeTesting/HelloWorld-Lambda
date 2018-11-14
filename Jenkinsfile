pipeline {
    agent {
        label 'testNode'
    }
    stages {
        stage('Build/Upload') {
            steps {
                sh './gradlew buildZip'
            }
        }
        stage('Run Terraform'){
            when {
                expression {
                    return env.BRANCH_NAME == ("master")
                }
            }
            steps{
                script{
                    withEnv(["PATH+terraform=${tool 'terraform'}"]){
                        withCredentials([
                                string(credentialsId: 'Carter-Research-ID', variable: 'USER_ID'),
                                string(credentialsId: 'aws-role-deploy', variable: 'ROLE_NAME')
                        ]){
                            sh "./gradlew deployTerraform -PUSER_ID=${USER_ID} -PROLE_NAME=${ROLE_NAME}"
                        }
                    }
                }
            }
        }
    }



}