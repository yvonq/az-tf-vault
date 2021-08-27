pipeline {
    agent none
    options {
        disableConcurrentBuilds()
    }
    stages {
		stage('Terraform Validate'){
					agent {
						docker {
							image 'hashicorp/terraform:latest'
							args  '--entrypoint=""'
						}
					}
					steps {
							ansiColor('xterm') {
							withCredentials([azureServicePrincipal(
							credentialsId: 'terraform-svc',
							subscriptionIdVariable: 'ARM_SUBSCRIPTION_ID',
							clientIdVariable: 'ARM_CLIENT_ID',
							clientSecretVariable: 'ARM_CLIENT_SECRET',
							tenantIdVariable: 'ARM_TENANT_ID'
						), string(credentialsId: 'access_key', variable: 'ARM_ACCESS_KEY')]) {
			 
						 
								sh """
										
								echo "Validate Terraform"
                                sh scripts/terraform.sh init
								sh scripts/terraform.sh validate
								"""
								   }
							}
					 }
				}

			stage('Terraform Plan'){
					agent {
						docker {
							image 'hashicorp/terraform:latest'
							args  '--entrypoint=""'
						}
					}
					steps {
							ansiColor('xterm') {
							withCredentials([azureServicePrincipal(
							credentialsId: 'terraform-svc',
							subscriptionIdVariable: 'ARM_SUBSCRIPTION_ID',
							clientIdVariable: 'ARM_CLIENT_ID',
							clientSecretVariable: 'ARM_CLIENT_SECRET',
							tenantIdVariable: 'ARM_TENANT_ID'
						), string(credentialsId: 'access_key', variable: 'ARM_ACCESS_KEY')]) {
			 
						 
								sh """
										
								echo "Validate Terraform"
								sh scripts/terraform.sh plan
								"""
								   }
							}
					 }
				}

		stage('Waiting for Approval 10 minutes Max'){
            steps {
                timeout(time: 10, unit: 'MINUTES') {
                    input (message: "Deploy the infrastructure?")
                }
            }
        
        }

		stage('Terraform Apply'){
					agent {
						docker {
							image 'hashicorp/terraform:latest'
							args  '--entrypoint=""'
						}
					}
					steps {
							ansiColor('xterm') {
							withCredentials([azureServicePrincipal(
							credentialsId: 'terraform-svc',
							subscriptionIdVariable: 'ARM_SUBSCRIPTION_ID',
							clientIdVariable: 'ARM_CLIENT_ID',
							clientSecretVariable: 'ARM_CLIENT_SECRET',
							tenantIdVariable: 'ARM_TENANT_ID'
						), string(credentialsId: 'access_key', variable: 'ARM_ACCESS_KEY')]) {
			 
						 
								sh """
										
								echo "Validate Terraform"
								sh scripts/terraform.sh apply 
								"""
								   }
							}
					 }
				}

		



    }
}
