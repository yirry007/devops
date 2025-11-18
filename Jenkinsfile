//pipeline script
pipeline {
    //任何一个代理（集群模式下）可用就可以执行
    agent any

    //定义一些环境信息
    environment {
        hello = "123456"
        world = "abcde"
    }

    //定义流水线的加工流程
    stages {
        stage('编译') {
            steps {
                echo "编译..."
                echo "$hello"
                echo "${world}"
                sh 'pwd && ls -alh'
                sh 'printenv'
                sh "echo ${GIT_BRANCH}"
            }
        }

        stage('测试') {
            steps {
                echo "测试"
            }
        }

        stage('打包') {
            steps {
                echo "打包"
            }
        }

        stage('部署') {
            steps {
                echo "部署"
            }
        }
    }
}