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
        // jenkins 运行过程中各环节可能会改变工作目录，因此需要保存初始的工作目录
        // 进入这个目录后打包的 jar包会放到这
        WS = "${WORKSPACE}"

        //引用jenkins配置的全局密钥信息
        DOCKER_SECRET = credentials('hub.docker.com')
        IMAGE_NAME = "piaomou/java-devops-demo"
        TAG = "latest"
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
                docker {
                    //jenkins 的容器外的宿主机上执行
                    image 'maven:4.0.0-rc-4-eclipse-temurin-25-alpine'//用完就杀掉
                    // /var/jenkins_home/appconfig/maven/.m2 为宿主机的路径
                    // /root/.m2 为 maven容器的路径，该路径在宿主机的 /var/lib/docker/volumes/jenkins-data/_data/appconfig/maven/settings.xml 中设置
                    args '-v /var/jenkins_home/appconfig/maven/.m2:/root/.m2'
                }
            }
            steps {
                echo "编译"
                //echo "$hello"
                //echo "${world}"

                //git 下载来的代码目录下
                sh 'pwd && ls -alh'
                sh 'mvn -v'
                //打包
                //自定义配置文件
                // 该指令的运行的最初位置是jenkins容器，因此应该写成容器中的配置文件地址（不是宿主机的配置文件地址） /var/jenkins_home/appconfig/maven/settings.xml
                // 每一行指令都是基于当前的jenkins环境信息，和上下指令无关，所以不能把 cd ${WS} 单独拆分
                sh 'cd ${WS} && mvn clean package -s "/var/jenkins_home/appconfig/maven/settings.xml" -Dmaven.test.skip=true'
                //sh 'mvn clean package -Dmaven.test.skip=true'
                //sh 'printenv'
                //sh "echo ${GIT_BRANCH}"
                //echo "${GIT_BRANCH}"
            }
        }

        stage('测试') {
            steps {
                echo "测试"
                sh 'pwd && ls -alh'
            }
        }

        stage('生成镜像') {
            steps {
                echo "打包"
                sh 'docker version'
                sh 'pwd && ls -alh'
                sh 'docker build -t piaomou/java-devops-demo .'
            }
        }

        stage('登录 Docker Hub') {
            steps {
                sh '''
                    echo "${DOCKER_SECRET_PSW}" | docker login -u "${DOCKER_SECRET_USR}" --password-stdin
                '''
            }
        }

        stage('推送镜像') {
            steps {
                sh '''
                    docker push ${IMAGE_NAME}:${TAG}
                '''
            }
        }

        stage('部署') {
            steps {
                echo "部署"
                sh 'docker rm -f java-devops-demo-dev'
                sh 'docker run -d -p 8888:8080 --name java-devops-demo-dev piaomou/java-devops-demo'
            }
            post {
                failure {
                    // One or more steps need to be included within each condition's block.
                    echo "Failed"
                }
                success {
                    echo "Success"
                }
            }
        }

        stage('发送报告') {
            steps {
                echo "准备发送报告"
            }
        }

        stage('部署生产环境') {
            steps {
                //手动输入版本【参数化构建】
                input {
                    message "需要部署到生产环境吗？"
                    ok "确认"
                    //submitter "PM"
                    parameters {
                        string(name: 'TAG', defaultValue: 'latest', description: '请指定生产环境需要部署的版本')
                    }
                }
                sh "echo 发布版本"

                // 版本的保存，代码的保存，镜像的保存
            }
        }
    }
}