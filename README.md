# glrunner - gitlab runner
CI/CD removes manual human interactions where possible - automating everything except the final manual code deployment to production.  You can build a complete CI/CD pipeline solution with one tool.  To use GitLab CI/CD, create a file called (dot) gitlab-ci.yml at the root of the project in your GitLab repository

You can clone this repository to spawn an EC2 with gitlab runner with aws cli, terraform, gomplate softwares.

If you are not using AWS, you can look at the userdata.sh script to manually build your gitlab-runner.

Instructions to spawn an gitlab-runner on AWS:
* Update vars.env file with appropriate aws resource information such as vpc-id, subnet-id, iam-profile, instance type, AMI-id and gitlab-runner registration token (look under your gitlab.project.setting,CI/CD, Runner).
* Run the gen-vars.sh script.  This should generate the userdata.sh and vars.tf.  Don't make changes directly in userdata.sh and vars.tf.  Instead, update the userdata.templ, vars.templ and vars.env and then run the ./gen-vars.sh script.
* Run terraform init, terraform apply --auto-approve to spawn a gitlab-runner instance connecting to your git repository.

Here is an example of building a gitlab runner with terraform, and aws cli 
```
#!/bin/bash
/usr/bin/timedatectl set-timezone America/Los_Angeles
/bin/hostname glrunner1
echo PS1=\"[\\u@glrunner1]\" >> /etc/bashrc 
systemctl restart sshd.service

apt-get update
apt-get install git -y
apt-get install unzip -y

git config --global http.sslverify false
HOSTNAME=`hostname`
REGTOKEN="Your-GitLab-Runner-Token-from-UI"
GITLAB=pssbxdev01.stanford.edu
curl -L --output /usr/local/bin/gitlab-runner https://gitlab-runner-downloads.s3.amazonaws.com/latest/binaries/gitlab-runner-linux-amd64
curl -L --insecure --output /usr/local/bin/gitlab.rootca https://your-website/rootca.txt
curl -o /usr/local/bin/terraform.zip https://releases.hashicorp.com/terraform/0.12.20/terraform_0.12.20_linux_amd64.zip
cd /usr/local/bin
unzip terraform.zip
chmod 755 /usr/local/bin/gitlab-runner
chmod 644 /usr/local/bin/gitlab.rootca
useradd --comment 'GitLab Runner' --create-home gitlab-runner --shell /bin/bash
echo "gitlab-runner register --tls-ca-file /usr/local/bin/gitlab.rootca"
gitlab-runner register -n \
  --tls-ca-file /usr/local/bin/gitlab.rootca \
  --url https://$GITLAB/ \
  --registration-token $REGTOKEN \
  --executor shell \
  --description "$HOSTNAME"

gitlab-runner run --syslog service &
```
By default, the gitlab runner configuration is under /etc/gitlab-runner/config.toml or $HOME/.gitlab-runner/config.toml

You can give tags to a gitlab-runner with option --tag-list tag1,tag2,tag3

