# jenkins-assemblyline-using-docker

## Tools Used :- Jenkins, Git, Github, Docker

## steps to do :- 
1.   Create container image that’s has Jenkins installed using dockerfile

2.   When we launch this image, it should automatically starts Jenkins service in the container.

3.   Create a job chain of job1, job2, job3 and job4 using build pipeline plugin in Jenkins

4.   Job1 : Pull the Github repo automatically when some developers push repo to Github.

5.   Job2 : By looking at the code or program file, Jenkins should automatically start the respective language interpreter install image container to deploy code ( eg. If code is of PHP, then Jenkins should start the container that has PHP already installed ).

6.   Job3 : Test your app if it is working or not.

7.   Job4 : if app is not working , then send email to developer with error messages.

8.   Create One extra job job5 for monitor : If container where app is running. fails due to any reson then this job should automatically start the container again.

## Steps 1:to create Jenkins docker container image :- 

create Dockerfile file 

![image](https://user-images.githubusercontent.com/63963025/146540876-dcb4ad6d-8d28-4372-be04-a5e67836eb15.png)

![image](https://user-images.githubusercontent.com/63963025/146540891-f16da9b6-e43a-4e2e-a46b-26fa484ac374.png)
after this build Docker container image using below command

docker build -t jenkins:v1 .

Note :- Before run above command goto directory where Dockerfile is placed.

## 2) Steps to setup Jenkins

step 1) launch docker container image

docker run -it -p 8080:80 --name jenkins jenkins:v1

step 2) check your jenkins image IP using

docker inspect jenkins | grep IP

copy IPAddress and paste it to browser url

http://{IPAddress}:port!


![Screenshot (168)](https://user-images.githubusercontent.com/63963025/146541235-78fb3c98-45fb-4ca3-906c-8be4b2c35766.png)

![Screenshot (170)](https://user-images.githubusercontent.com/63963025/146541268-f21ac73d-7f3c-4f6e-9aee-33e601a8ce34.png)


after this copy Administrator password from terminal from where you launch docker image and paste it.

To change password goto: ManageJenkins -> Manage Users -> press setting icon -> goto password section and set new password

Steps to download some plugins required in this task

Download below plugins from Manage Jenkins -> Manage Plugins -> Available tab -> search below plugins and tick mark -> Install Without restart -> After this click on restart after install checkbox.

<b>Build Pipeline Plugin, Email Extension Plugin, Git plugin, GitHub plugin,

Publish Over SSH, SSH Agent Plugin, SSH Build Agents plugin, SSH Pipeline Steps, SSH plugin, SSH2 Easy Plugin</b>

To configure SSH service in Jenkins goto Manage Jenkins -> Configuration system -> SSH remote hosts -> set hostname(IP address of your base os) and ssh port(22) of your base OS.

To configure E-mail Notification goto Manage Jenkins -> Configuration system -> E-mail Notification ->

SMTP server : smtp.gmail.com

Use SMTP Authentication: allow

User Name: Email address

Password: email password

Use SSL: allow

SMTP Port: 465


![Screenshot (177)](https://user-images.githubusercontent.com/63963025/146541510-2e03b487-2bde-4065-ba64-2968cceaf59b.png)
![Screenshot (175)](https://user-images.githubusercontent.com/63963025/146541514-54b4e7f6-341d-4cdc-a429-82685fecbc98.png)
![Screenshot (176)](https://user-images.githubusercontent.com/63963025/146541516-4344d1cc-fafd-40c2-bdb6-d4a4b65890ee.png)

Publish over SSH configuration

![ssh over ssh configure](https://user-images.githubusercontent.com/63963025/146541771-2d7d6d9d-15df-47b2-a2a2-6aec8775f762.png)

<b> steps to implement Job 1</b>

Create new Job named as Job1 from New Item section and select Free style project and press OK to confirm

In Job1 we are going to configure SSH to connect with our base system to perform various tasks and configuring git/Github to clone project automatically when some new commit is done on repository and then whole project will be copy to base OS at /data1 directory.

After this click on job1 and goto Configure section and setup everything same as below

also in github section add your github 

please select poll scm

![poll scm](https://user-images.githubusercontent.com/63963025/146542392-7d52d27d-fda5-429e-bb58-59e4ff9442d7.png)

![Screenshot (179)](https://user-images.githubusercontent.com/63963025/146542035-626ef19e-45a1-425e-bfe9-4653ce6d0ddb.png)


![Screenshot (178)](https://user-images.githubusercontent.com/63963025/146542032-5daa1d6e-402d-4c67-b25f-8ffef1b338ac.png)

![j1](https://user-images.githubusercontent.com/63963025/146542455-407c21c2-cab5-40e2-837d-0561b3f129ba.png)

![j 1](https://user-images.githubusercontent.com/63963025/146542481-8dee127e-970a-4c54-8bb9-b7420bbd6b61.png)
Now Apply changes and press Save.

Steps to implement Job2

In Job2 we are checking /data1 directory which is copy of our repository contents. Here we checking extension of files and match with according to requirements

For example :- ls /data | grep .php -> if this output is matched then we will launch new container image which helps to depoly php page.

Create Job2 same as Job1 but configuration will be same as below :


![Screenshot (181)](https://user-images.githubusercontent.com/63963025/146542557-76b519a8-2ba9-4f7d-a690-87c34db1e6b0.png)
![Screenshot (182)](https://user-images.githubusercontent.com/63963025/146542559-89474bd3-40b9-4092-a7c0-7b590637a2ac.png)
![Screenshot (183)](https://user-images.githubusercontent.com/63963025/146542552-d555a348-e0ff-44c7-a84f-0d3aaed775be.png)

Now press save to apply new changes.

## Steps to implement Job3 & Job4

According to Job3 we are testing our App by checking its status using

status=$(curl -o /dev/null -s -w "%{http_code}" 172.17.0.3:80)

here 172.17.0.3:80 is IP and Port of my PHP container image.

Email will notify if Build is failed.

Follow below steps to configure Job3.

![Screenshot (187)](https://user-images.githubusercontent.com/63963025/146542690-2b34268e-71c9-4e20-a212-56ae069ba512.png)
![Screenshot (184)](https://user-images.githubusercontent.com/63963025/146542696-85a36f58-e908-4fb7-a718-45e451322a6e.png)
![Screenshot (185)](https://user-images.githubusercontent.com/63963025/146542698-833b8fc3-6419-4c5a-9cf0-51379ad60f54.png)
![Screenshot (186)](https://user-images.githubusercontent.com/63963025/146542700-a44b9691-8750-4938-90d3-ae109d5b249b.png)

## Steps to implement Job5

Here we check deploy container image is running or not if container image is down then this job will restart container image.

Steps to configure Job5

![Screenshot (189)](https://user-images.githubusercontent.com/63963025/146542771-cc1ebc8d-02fa-47b8-ab74-9634bf3e3e66.png)
![Screenshot (191)](https://user-images.githubusercontent.com/63963025/146542776-3fa5d450-7c28-4106-9a80-6b2478ea5149.png)
![Screenshot (192)](https://user-images.githubusercontent.com/63963025/146542778-097bb3fb-b9ed-4f7c-811d-f23b0b2d93e2.png)
![Screenshot (193)](https://user-images.githubusercontent.com/63963025/146542780-b9333c2c-b4d2-4345-bdae-b8c094e97ae1.png)

This build periodically will check in every 5 min container is running or not.

Steps to implement Build Pipeline plugin

Click on + icon

Enter Project name and tick Build Pipeline View then apply and save


![pipeline](https://user-images.githubusercontent.com/63963025/146542818-171b5607-a143-4181-9b37-25f757565c6f.png)

<b>Build pipeline View will look same as below</b>


![Screenshot (194)](https://user-images.githubusercontent.com/63963025/146542851-c13be4ee-46bd-4e36-a96f-bcfbf8d477fc.png)



