# cicdproject
Simple examples to help you build great software quickly
# --- 1st method using jenkinsfile
First create the namespace and add the jenkins inside the project
Login into the jenkins using same cluster credentials
In GitHub create a Jenkinsfile inside that write pipeline complete CI CD
Like in agent maven build in stages number of stages (build,test,create a container,deploy)
Create a Build Confing file using Jenkinsfile and Build
# --- 2nd method using yaml file
Create a namespace and add jenkins and login using same cluster credentials 
in CLI create a yaml file inside that file write script BuildConfig and Jenkinsfile Pipeline CI CD
-- (oc create -f yaml file)  using this create a BuildConfig
-- (oc start-build BuildConfig name)  start the build
-- (oc get builds -w)  see the updates of builds



buildconfig
---apiVersion: build.openshift.io/v1
kind: BuildConfig
metadata:
  name: example
  namespace: java-project
spec:
  source:
    git:
      ref: master
      uri: 'https://github.com/openshift/ruby-ex.git'
    type: Git
  strategy:
    jenkinsPipelineStrategy:
      jenkinsfilePath: Jenkinsfile 
