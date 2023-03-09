#! /usr/bin/env groovy

pipeline {

  agent {
    label 'maven'
  }

  stages {
    stage('Build') {
      steps {
        echo 'Building..'
        
       sh 'mvn clean package'
      }
    }
    stage('Create Container Image') {
      steps {
        echo 'Create Container Image..'
        
        script {

          openshift.withCluster() { 
  openshift.withProject("java-project") {
  
    def buildConfigExists = openshift.selector("bc", "jenkins-cicd").exists() 
    
    if(!buildConfigExists){ 
      openshift.newBuild("--jenkins-cicd", "--docker-image=registry.redhat.io/jboss-eap-7/eap74-openjdk8-openshift-rhel7", "--binary") 
    } 
    
    openshift.selector("bc", "jenkins-cicd").startBuild("--from-file=target/sample.war", "--follow") } }

        }
      }
    }
    stage('Deploy') {
      steps {
        echo 'Deploying....'
        script {

          openshift.withCluster() { 
  openshift.withProject("java-project") { 
    def deployment = openshift.selector("dc", "jenkins-cicd") 
    
    if(!deployment.exists()){ 
      openshift.newApp('jenkins-cicd', "--as-deployment-config").narrow('svc').expose() 
    } 
    
    timeout(5) { 
      openshift.selector("dc", "jenkins-cicd").related('pods').untilEach(1) { 
        return (it.object().status.phase == "Running") 
      } 
    } 
  } 
}

        }
      }
    }
  }
}
