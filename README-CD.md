1. 
    The instance is running Amazon Linux 2023 AMI 2023.9.20251014.0 x86_64 HVM kernel-6.1. 5GB should be plenty to run it unless the docker container multiplies in size dramatically. The SG allows SSH traffic from the WSU network and all traffic from my own personal network, as well as from within the VPC. Finally, HTML traffic is allowed from anywhere.

    Installing docker on this instance simply requires `yum install docker`, though `            service docker start`, `systemctl enable docker`, and `usermod -aG docker ec2-user` are necessary to finish the setup. To confirm docker is working properly you could always use the Hello World container, but it's not really any more difficult to just run the container for this project: `docker pull kairoundmountain/project3:latest` followed by `docker run --name project3 -d -p 80:80 --restart always kairoundmountain/project3:latest`, and then access the instances IP address to confirm the website is served.

    The bash script is very simple: it stops and removes the running container, deletes the image, pulls a new version of the image, then runs it. To verify it worked, use `docker ps` to ensure the container is running, and `docker image ls` to see when the image was last updated. The bash script can be found [here](https://github.com/WSU-kduncan/cicdf25-kairoundmountain/blob/main/deployment/update-container.sh).

2. 
    Installing webhook was a little trickier since I'm using Amazon Linux and webhook doesn't appear to be available on yum. Instead, I used wget to grab the pre-compiled linux amd64 binary of the latest release, then just had to untar it. Verifying a successful installation should just be as simple as checking if there's an executable file named 'webhook' in your extracted folder or not.

    The webhook definition file, [hooks.json](https://github.com/WSU-kduncan/cicdf25-kairoundmountain/blob/main/deployment/hooks.json) mainly specifies the location of the script to be executed when it receives a POST and restrictions for the specific formatting of the payload, most importantly the token that must be included.

    Using `./webhook -hooks hooks.json -verbose` (depending on file locations you may need to specify in more detail), it should quickly inform you whether the definition file was loaded correctly. It should also actively display logs into the terminal.

    The [webhook service file](https://github.com/WSU-kduncan/cicdf25-kairoundmountain/blob/main/webhook.service) specifies where the webhook executable can be found, that it should be restarted always with a 1 second delay between attempts, which user it should be run as, and that it should be treated as a simple process (which is beyond the scope of this). It also specifies a working directory, and that error logging should be sent to journalctl.
    `sudo systemctl start webhook` will start it, and `sudo systemctl enable webhook` will have it launch on startup.

    You can verify the service is working properly using `journalctl -u webhook.service -f` and sending it a payload.

3. 
    I chose to configure Dockerhub to send the payload, since if I were to use github I'd have no guarantee the container image had actually reached Dockerhub yet. It's really simple to do, simply go to the dockerhub repo, click 'webhooks' and add your webhook url.

    To 

Resources:

https://github.com/adnanh/webhook
https://blog.devgenius.io/build-your-first-ci-cd-pipeline-using-docker-github-actions-and-webhooks-while-creating-your-own-da783110e151
https://medium.com/@benmorel/creating-a-linux-service-with-systemd-611b5c8b91d6

Deepseek AI. Prompt: How do I enable logging for a systemctl service?