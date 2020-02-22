# glrunner - gitlab runner
CI/CD removes manual human interactions where possible - automating everything except the final manual code deployment to production.  You can build a complete CI/CD pipeline solution with one tool.  To use GitLab CI/CD, create a file called (dot) gitlab-ci.yml at the root of the project in your GitLab repository

You can clone this repository to spawn an EC2 with gitlab runner with aws cli, terraform, gomplate softwares.

If you are not using AWS, you can look at the userdata.sh script to manually build your gitlab-runner.

Instructions to spawn an gitlab-runner on AWS:
* Update vars.env file with appropriate aws resource information such as vpc-id, subnet-id, iam-profile, instance type, AMI-id and gitlab-runner registration token (look under your gitlab.project.setting,CI/CD, Runner).
* Run the gen-vars.sh script.  This should generate the userdata.sh and vars.tf.  Don't make changes directly in userdata.sh and vars.tf.  Instead, update the userdata.templ, vars.templ and vars.env and then run the ./gen-vars.sh script.
* Run terraform init, terraform apply --auto-approve to spawn a gitlab-runner instance connecting to your git repository.
