node {

  stage('Build') {
    checkout scm
    sh "docker build -t twelvelabs/coffee-svc:0.0.${env.BUILD_NUMBER} ."
  }

  stage('Test') {
    echo "lol, tests"
  }

  stage('Publish') {
    sh "docker tag twelvelabs/coffee-svc:0.0.${env.BUILD_NUMBER} twelvelabs/coffee-svc:latest"
    sh "docker push twelvelabs/coffee-svc:0.0.${env.BUILD_NUMBER}"
    sh "docker push twelvelabs/coffee-svc:latest"
  }

  stage('Deploy') {
    sh "helm install ./charts/coffee-svc --name coffee-svc --set image.tag=0.0.${env.BUILD_NUMBER},domain=coffee.svc.cluster.twelvelabs.com"
  }

}
