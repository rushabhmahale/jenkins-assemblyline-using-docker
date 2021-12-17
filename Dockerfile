FROM centos 

RUN yum install wget -y 

RUN yum install sudo -y 

RUN yum install net-tools -y 

RUN yum install initscripts -y 

RUN yum install java-11-openjdk.x86_64 -y

RUN sudo wget -O /etc/yum.repos.d/jenkins.repo \
    https://pkg.jenkins.io/redhat-stable/jenkins.repo

RUN sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key

CMD ["java". "-jar", "/usr/lib/jenkins/jenkins.war"]

RUN sudo yum install jenkins --nobest -y 

RUN echo -e "jenkins ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

RUN sudo yum install git -y 

RUN sudo yum install openssh-server -y 

USER jenkins 
ENV USER jenkins 

EXPOSE 8084 

EXPOSE 80
