pipeline {
    agent {
        label 'ahmad-node'
    }
    
    stages {
        stage('Terraform Apply') {
            steps {
                dir('terraform') {
                    sh '''
                        export OS_AUTH_URL="https://cloud.crplab.ru:5000"
                        export OS_PROJECT_NAME="students"
                        export OS_USERNAME="master2022" 
                        export OS_PASSWORD="J8F3LGa*7KU7ye"
                        export OS_INTERFACE="public"
                        export OS_IDENTITY_API_VERSION="3"
                        
                        openstack token issue
                        terraform init
                        terraform apply -auto-approve \
                            -var="image_name=ubuntu-20.04" \
                            -var="flavor_name=m1.small" \
                            -var="network_name=sutdents-net" \
                            -var="keypair=jenkins-key"
                        terraform output -raw vm_ip > ../ansible/ip.txt
                    '''
                }
            }
        }
        
        stage('Ansible Deploy') {
            steps {
                dir('ansible') {
                    sh '''
                        VM_IP=$(cat ip.txt)
                        cat > inventory.ini << EOL
[servers]
vm ansible_host=$VM_IP ansible_user=ubuntu ansible_ssh_private_key_file=/var/lib/jenkins/.ssh/jenkins_deploy_rsa
EOL
                        ansible-playbook -i inventory.ini \
                            --ssh-common-args="-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null" \
                            playbook.yml
                    '''
                }
            }
        }
    }
}
