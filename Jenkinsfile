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
    withCredentials([[
      $class: 'UsernamePasswordMultiBinding',
      credentialsId: '5a04193a-3630-4094-9945-09641dcd9851',
      usernameVariable: 'USERNAME',
      passwordVariable: 'PASSWORD'
    ]]) {
      sh "docker login --username $USERNAME --password $PASSWORD"
      sh "docker push twelvelabs/coffee-svc:0.0.${env.BUILD_NUMBER}"
      sh "docker push twelvelabs/coffee-svc:latest"
      sh "docker logout"
    }
  }

  stage('Deploy') {
    def appName = "coffee-${env.BRANCH_NAME}"
    if (env.BRANCH_NAME == 'master') {
      appName = "coffee"
    }
    sh "helm upgrade ${appName} ./charts/coffee-svc --install --set image.tag=0.0.${env.BUILD_NUMBER}
  }

}
