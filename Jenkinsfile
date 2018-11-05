pipeline {
    agent {
        label 'testNode'
    }
    stages {
        stage('Build') {
            steps {
                sh './gradlew'
            }
        }
        stage('Run Terraform'){
            steps{
                script{
                    def terraformHome = tool 'terraform'
                    withEnv(["PATH+terraform=${tool 'terraform'}"]){
                        withCredentials([
                                string(credentialsId: 'Carter-Research-ID', variable: 'USER_ID'),
                                string(credentialsId: 'aws-role-deploy', variable: 'ROLE_NAME')
                        ]){
                            sh "./gradlew deployTerraform -PUSER_ID=${USER_ID} -PROLE_NAME=${ROLE_NAME} -PterraformHome=${terraformHome}"
                        }
                    }
                }
            }
        }
    }



}