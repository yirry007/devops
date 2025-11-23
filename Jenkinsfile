//pipeline script
pipeline {
    //任何一个代理（集群模式下）可用就可以执行
    agent any

    //之后所有stage都必须指定自己的agent
    //agent none

    //定义一些环境信息
    environment {
        hello = "123456"
        world = "abcdef"
    }

    //定义流水线的加工流程
    stages {
        stage('环境检查') {
            steps {
                sh 'printenv'
                echo "正在检查基本信息..."
                sh "java -version"
                sh "git --version"
                sh "docker version"
                sh 'pwd && ls -alh'
                sh "echo $hello"
                sh "echo ${world}"
            }
        }

        stage('编译') {
            agent {
                docker { image 'maven:3-alpine' }
            }
            steps {
                //echo "编译..."
                //echo "$hello"
                //echo "${world}"

                //git 下载来的代码目录下
                sh 'pwd && ls -alh'
                sh 'mvn -v'
                //打包
                sh 'mvn clean package -Dmaven.test.skip=true'
                //sh 'printenv'
                //sh "echo ${GIT_BRANCH}"
                //echo "${GIT_BRANCH}"
            }
        }

        stage('测试') {
            steps {
                echo "测试"
            }
        }

        stage('生成镜像') {
            steps {
                echo "打包"
                sh 'docker version'
                sh 'pwd && ls -alh'
            }
        }

        stage('部署') {
            steps {
                echo "部署"
            }
        }
    }
}