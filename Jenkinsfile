node {

  def gitCommitSHA    = sh(returnStdout: true, script: 'git rev-parse --short=12 HEAD').trim()
  def gitBranchName   = env.BRANCH_NAME

  def appName         = "coffee-svc"
  def chartName       = "./charts/${appName}"
  def releaseName     = (gitBranchName == 'master') ? "${appName}" : "${appName}-${gitBranchName}"

  def dockerImageRepo = "twelvelabs/${appName}"
  def dockerImageTag  = "${gitCommitSHA}"


  stage('Build') {
    checkout scm
    sh "docker build -t ${dockerImageRepo}:${gitCommitSHA} ."
  }

  stage('Test') {
    sh "docker run --rm -v ${dockerImageRepo}:${gitCommitSHA} bundle exec rake test"
  }

  stage('Publish') {
    sh "docker tag ${dockerImageRepo}:${gitCommitSHA} ${dockerImageRepo}:${gitBranchName}"
    withCredentials([[
      $class: 'UsernamePasswordMultiBinding',
      credentialsId: '5a04193a-3630-4094-9945-09641dcd9851',
      usernameVariable: 'USERNAME',
      passwordVariable: 'PASSWORD'
    ]]) {
      sh "docker login --username $USERNAME --password $PASSWORD"
      sh "docker push ${dockerImageRepo}:${gitCommitSHA}"
      sh "docker push ${dockerImageRepo}:${gitBranchName}"
      sh "docker logout"
    }
  }

  stage('Deploy') {
    sh "helm upgrade ${releaseName} ${chartName} --install --set image.repository=${dockerImageRepo},image.tag=${gitCommitSHA}
  }

}
