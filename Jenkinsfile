pipeline {
    agent {
        docker {
            image 'casjaysdev/go:latest'
            args '-e CGO_ENABLED=0 -e GOFLAGS=-buildvcs=false'
        }
    }

    environment {
        PROJECTNAME = 'casns'
        PROJECTORG  = 'casapps'
    }

    stages {
        stage('Dependencies') {
            steps {
                sh 'go mod download'
            }
        }

        stage('Build') {
            steps {
                sh 'go build -ldflags="-s -w" -o binaries/casns ./src/'
            }
        }

        stage('Test') {
            steps {
                sh '''
                    mkdir -p /tmp/casapps
                    COVDIR=$(mktemp -d /tmp/casapps/casns-XXXXXX)
                    go test -coverprofile="$COVDIR/coverage.out" ./src/...
                '''
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
}
