pipeline {
    environment {
        registry = "ravijaya/add2vals"
	dockerImage = ''
        //DOCKER_PWD = "dockerhub"
    }

    agent none 
    stages {
        stage('Build') {
	    agent {
		docker {
		     image 'python:2-alpine'
		}
	    }
            steps {
		sh 'python -m py_compile sources/add2vals.py sources/calc.py'
		stash(name: 'compiled-results', includes: 'sources/*.py*')
	    }
	}
        stage('Test') {
	    agent {
	    	docker {
		    image 'qnib/pytest'
		}
	    } 	
	    steps {
		    sh 'py.test --junit-xml test-reports/results.xml sources/test_calc.py'
	    }
	    post {
		 always {
			junit 'test-reports/results.xml'
		 }
	     }
	}
	stage('Deliver & Push Docker image') {
	    agent any 
            environment {
		VOLUME = '$(pwd)/sources:/src'
		IMAGE = 'cdrx/pyinstaller-linux:python2'
	    }
	    steps {
		dir(path: env.BUILD_ID) {
		    unstash(name: 'compiled-results')
		    sh "docker run --rm -v ${VOLUME} ${IMAGE} 'pyinstaller -F add2vals.py'"	
	        
		
		// sh 'docker image build -t $registry:$BUILD_NUMBER .'
		// sh 'docker login -u ravijaya -p $DOCKER_PWD'
		// sh 'docker image push $registry:$BUILD_NUMBER'
		// sh "docker image rm $registry:$BUILD_NUMBER"
		}
		
		node {

    		    docker.withRegistry('https://hub.docker.com', 'dockerhub') {
        	        def customImage = docker.build("${registry}:${env.BUILD_ID}")

        	        /* Push the container to the custom Registry */
        	        customImage.push()
                    }
                }
	    }	
            post {
		success {
		   archiveArtifacts "${env.BUILD_ID}/sources/dist/add2vals"
		   sh "docker run --rm -v ${VOLUME} ${IMAGE} 'rm -rf build dist'"
		}
		
	    }				
	}
	
    }
}

