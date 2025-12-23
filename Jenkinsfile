pipeline {
    agent any
    
    stages {
        stage('Terraform Apply') {
            steps {
                dir('terraform') {
                    sh '''
                        # Load OpenStack credentials
                        [ -f ~/.openstack/test-rc.sh ] && source ~/.openstack/test-rc.sh
                        
                        # Initialize and apply
                        terraform init
                        terraform apply -auto-approve \
                            -var="image_name=ubuntu-20.04" \
                            -var="flavor_name=m1.small" \
                            -var="network_name=sutdents-net" \
                            -var="keypair=jenkins-key"
                        
                        # Save IP
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
                        
                        # Create inventory
                        cat > inventory.ini << EOL
[servers]
vm ansible_host=$VM_IP ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/jenkins_deploy_rsa
EOL
                        
                        # Run playbook
                        ansible-playbook -i inventory.ini \
                            --ssh-common-args="-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null" \
                            playbook.yml
                    '''
                }
            }
        }
    }
}
