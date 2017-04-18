node {
  env.RAILS_ENV = 'test'
  stage('Build') {
    checkout scm

    sh '''#!/bin/bash -l
    rvm use 2.1.2@searchworks --create
    gem install bundler
    bundle install
    bundle exec rake db:migrate
    '''
  }

  stage('Test') {
    withCredentials([string(credentialsId: 'sw solr url', variable: 'TEST_SOLR_URL')]) {
      sh '''#!/bin/bash -l
      rvm use 2.1.2@searchworks
      bundle exec rake jenkins
      '''
    }
  }
}
