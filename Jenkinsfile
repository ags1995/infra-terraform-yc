pipeline {
    agent {
        label 'ahmad-node'  // Force execution on ahmad-node
    }
    
    stages {
        stage('Check Tools') {
            steps {
                sh '''
                    echo "Running on: $(hostname)"
                    echo "Checking required tools..."
                    
                    # Install Terraform if missing
                    if ! command -v terraform >/dev/null 2>&1; then
                        echo "Installing Terraform..."
                        sudo snap install terraform --classic
                    fi
                    
                    # Install Ansible if missing
                    if ! command -v ansible >/dev/null 2>&1; then
                        echo "Installing Ansible..."
                        sudo apt update
                        sudo apt install -y ansible
                    fi
                    
                    # Verify installations
                    terraform --version
                    ansible --version
                '''
            }
        }
        
        stage('Terraform Apply') {
            steps {
                dir('terraform') {
                    sh '''
                        # Load OpenStack credentials
                        if [ -f ~/.openstack/test-rc.sh ]; then
                            source ~/.openstack/test-rc.sh
                            echo "OpenStack credentials loaded"
                        else
                            echo "ERROR: OpenStack credentials not found!"
                            exit 1
                        fi
                        
                        # Initialize and apply
                        terraform init
                        terraform apply -auto-approve \
                            -var="image_name=ubuntu-20.04" \
                            -var="flavor_name=m1.small" \
                            -var="network_name=sutdents-net" \
                            -var="keypair=jenkins-key"
                        
                        # Save IP
                        terraform output -raw vm_ip > ../ansible/ip.txt
                        echo "VM IP: $(cat ../ansible/ip.txt)"
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
