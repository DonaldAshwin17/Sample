stage('Build Docker Image') {
    container('docker-container') {
        withEnv(["DOCKER_TLS_VERIFY=1"]) {
            withCredentials([usernamePassword(credentialsId: 'harbor-credentials-id', 
                                              usernameVariable: 'HARBOR_USERNAME', 
                                              passwordVariable: 'HARBOR_PASSWORD')]) {
                sh """
                docker login -u ${HARBOR_USERNAME} -p ${HARBOR_PASSWORD} harbor-url-here
                docker build -t ${image_full_name}:${image_tag} -f dlr-sid/dev/Docker/Dockerfile .
                """
            }
        }
    }
}

stage('Push Docker Image') {
    container('docker-container') {
        withEnv(["DOCKER_TLS_VERIFY=1"]) {
            withCredentials([usernamePassword(credentialsId: 'harbor-credentials-id', 
                                              usernameVariable: 'HARBOR_USERNAME', 
                                              passwordVariable: 'HARBOR_PASSWORD')]) {
                sh """
                docker login -u ${HARBOR_USERNAME} -p ${HARBOR_PASSWORD} harbor-url-here
                docker push ${image_full_name}:${image_tag}
                """
            }
        }
    }
}
