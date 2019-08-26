
	try {
	   node("jenkins_test_server") {
	        env.JAVA_HOME=tool name:  'myjava', type: 'jdk'
            	def mvnHome=tool name:  'mymaven', type: 'maven'
            	def mvnCMD="${mvnHome}/bin/mvn"
			
		stage ('checkout') {
			checkout scm 
		}
    
		stage('Puppet Install') {
		        echo "Installing Puppet Agent"
			steps {
				scripts {
				    sh "whoami"
				    sh "sudo ufw allow 8140"
				    sh "wget https://apt.puppetlabs.com/puppet6-release-bionic.deb"
				    sh "sudo dpkg -i puppet6-release-bionic.deb"
				    sh "sudo apt-get -y install puppet"
				    sh " sleep 100s"
				    sh "sudo /opt/puppetlabs/bin/puppet resource service puppet ensure=running enable=true"
				    sh "sudo /opt/puppetlabs/bin/puppet agent --waitforcert 60"
				    timeout(time: 1, unit: 'MINUTES')
				    }
			}
		    }
        	}   

	   node {
	        env.JAVA_HOME=tool name:  'myjava', type: 'jdk'
            	def mvnHome=tool name:  'mymaven', type: 'maven'
            	def mvnCMD="${mvnHome}/bin/mvn"
    
		stage('PuppetSign') {
			echo "Signing Client Certificate"
			sh "sudo /opt/puppetlabs/bin/puppetserver ca sign puppetagent1"
		    	}
        	}
        
	   node("jenkins_test_server") {
		stage('Docker_Installation') {
			steps {
				echo "Installing Docker on PuppetAgent"
				sh "sudo /opt/puppetlabs/bin/puppet agent -t"
				timeout(time: 1, unit: 'MINUTES')
				}
            	}
            
            	stage('Docker_Image_Pull') {
			steps {
				echo "Installing Docker on PuppetAgent"
				dockerfile {
					filename 'Dockerfile'
					dir '/var/lib/jenkins/devops-training'
					label 'projcert'
					args '-v /tmp:/tmp'
					}
			}
		}
            
            //stage('Docker_Deployment') {			
		    //    echo "Deploying A Docker Container with PHP Website"
		    //    sh "cd /var/lib/jenkins/devops-training"
            //    sh "docker build -t projcert ."
            //    timeout(time: 4, unit: 'MINUTES')
            //}
            
		   stage('Docker_Container_Run') {
			steps {
		        	echo "Running Docker Container on port 8010"
                		sh "docker run -itd -p 8010:80 --name=my_cert_proj projcert"
            		} 
		   }
            
    		   stage('Testing') {
			steps {
    		    		echo "Testing PHP Website"
			    	dir("cd /var/lib/jenkins/devops-training"){
			    	sh "sudo java -jar projCert.jar"
			    	timeout(time: 1, unit: 'MINUTES')
			    		}
				}	
    		   }
            
		   stage('clean up') {			
			echo "cleaning up the workspace"
			cleanWs()
	  	   }
	   } 	       
   }
    
    finally {
		(currentBuild.result != "ABORTED") && node("master") {
		// Send e-mail notifications for failed or unstable builds.
		// currentBuild.result must be non-null for this step to work.
		step([$class: 'Mailer',notifyEveryUnstableBuild: true,recipients: 'laanuo@yahoo',sendToIndividuals: true])
		}
	}

