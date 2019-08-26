pipeline {
   //agent none
	node ("jenkins_test_server") {	
      		env.JAVA_HOME=tool name:  'myjava', type: 'jdk'
      		def mvnHome=tool name:  'mymaven', type: 'maven'
      		def mvnCMD="${mvnHome}/bin/mvn"

           stages {
		stage ('checkout') {
			checkout scm 
		  }
    	  	stage ('compilation 1') {
			echo "Installing Puppet Agent"
			steps {
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

	node ("master") {		
		stage ('compilation 2') {
	        	echo "Signing Client Certificate"

			steps {
			  sh "sudo /opt/puppetlabs/bin/puppetserver ca sign puppetagent1"
			}
		  }
	}
	
	node ("jenkins_test_server") {
	   stages {
		stage ('compilation 3') {
	    		echo "Installing Docker on PuppetAgent"
			steps {
			   sh "sudo /opt/puppetlabs/bin/puppet agent -t"
              		   timeout(time: 1, unit: 'MINUTES')
			}
		  }
		  stage ('docker') {
			  echo "Installing Docker on PuppetAgent"
			  dockerfile {
				filename 'Dockerfile'
				dir '/var/lib/jenkins/devops-training'
				label 'projcert'
				args '-v /tmp:/tmp'
			  }
			}
		stage ('docker-run') {
			echo "Running Docker Container"
			docker.image("my_cert_proj").withRun('-p 8010:80') {c ->
			sh "curl -i http://${hostIp(c)}:8080/"
			}
            	   } 
		}
	}
          stage('clean up') {			
		    echo "cleaning up the workspace"
			cleanWs()
			//label "jenkins_test_server"
		  }		  
}
   
}
