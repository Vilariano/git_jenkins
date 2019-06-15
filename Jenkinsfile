node {
  checkout scm
  docker.image('selenium/standalone-chrome-debug').withRun('-d -p 4444:4444 -p 59000:59000 --name selenium') { c ->
    docker.image('ruby').inside("--link ${c.id}:selenium") {
      sh 'gem install bundler'
      sh 'bundle install'
      sh 'cucumber -p desk_ci'
    }
  }
}