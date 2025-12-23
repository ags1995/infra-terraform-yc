pipeline {
    agent {
        label 'ahmad-node'  // This tells Jenkins to run ONLY on ahmad-node
    }
    
    stages {
        stage('Check Environment') {
            steps {
                sh '''
                    echo "=== Running on: $(hostname) ==="
                    echo "Node: ahmad-node"
                    echo "User: $(whoami)"
                    echo "Date: $(date)"
                    
                    # Check if OpenStack credentials are available
                    if [ -f ~/.openstack/test-rc.sh ]; then
                        echo "✅ Found OpenStack RC file"
                        source ~/.openstack/test-rc.sh
                    else
                        echo "❌ ERROR: ~/.openstack/test-rc.sh not found!"
                        echo "Please create this file on ahmad-node with OpenStack credentials"
                        exit 1
                    fi
                    
                    # Test OpenStack connection
                    openstack token issue && echo "✅ OpenStack authentication successful"
                    
                    # Check required tools
                    command -v terraform && echo "✅ Terraform installed" || echo "❌ Terraform missing"
                    command -v ansible && echo "✅ Ansible installed" || echo "❌ Ansible missing"
                    command -v openstack && echo "✅ OpenStack CLI installed" || echo "❌ OpenStack CLI missing"
                '''
            }
        }
        
        stage('Terraform Apply') {
            steps {
                dir('terraform') {
                    sh '''
                        set -e  # Exit on error
                        source ~/.openstack/test-rc.sh
                        
                        echo "Initializing Terraform..."
                        terraform init
                        
                        echo "Creating VM with OpenStack..."
                        terraform apply -auto-approve \
                            -var="image_name=ubuntu-20.04" \
                            -var="flavor_name=m1.small" \
                            -var="network_name=sutdents-net" \
                            -var="keypair=jenkins-key"
                        
                        # Get the VM IP
                        terraform output -raw vm_ip > ../ansible/ip.txt
                        VM_IP=$(cat ../ansible/ip.txt)
                        echo "✅ VM created with IP: $VM_IP"
                    '''
                }
            }
        }
        
        stage('Wait for SSH') {
            steps {
                dir('ansible') {
                    sh '''
                        set -e
                        VM_IP=$(cat ip.txt)
                        echo "Waiting for SSH access on $VM_IP..."
                        
                        # Try for 60 seconds
                        for i in {1..30}; do
                            if nc -z $VM_IP 22 2>/dev/null; then
                                echo "✅ SSH is ready"
                                break
                            fi
                            sleep 2
                            echo "Still waiting... ($((i*2)) seconds)"
                        done
                        
                        # Final check
                        if ! nc -z $VM_IP 22 2>/dev/null; then
                            echo "❌ SSH never became available"
                            exit 1
                        fi
                    '''
                }
            }
        }
        
        stage('Deploy with Ansible') {
            steps {
                dir('ansible') {
                    sh '''
                        set -e
                        VM_IP=$(cat ip.txt)
                        
                        echo "Creating Ansible inventory for VM: $VM_IP"
                        cat > inventory.ini << EOL
[servers]
lab5-vm ansible_host=$VM_IP ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/jenkins_deploy_rsa
EOL
                        
                        echo "Deploying nginx with Ansible..."
                        ansible-playbook -i inventory.ini \
                            --ssh-common-args="-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null" \
                            playbook.yml
                        
                        echo "✅ Deployment complete!"
                    '''
                }
            }
        }
        
        stage('Verify') {
            steps {
                echo "🎉 Pipeline completed successfully on ahmad-node!"
                echo "OpenStack VM created and configured with nginx."
            }
        }
    }
    
    post {
        always {
            echo "=== Pipeline finished on $(date) ==="
        }
        success {
            echo "✅ SUCCESS: All stages completed!"
        }
        failure {
            echo "❌ FAILURE: Check the logs above for errors"
        }
    }
}
