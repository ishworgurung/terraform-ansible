# Pull ansible-playbook docker image
Will pull the docker image from dockerhub

    $ docker pull isgdocker/ansible-playbook:latest

# If you prefer to roll your own, build ansible-playbook docker image
Roll your own if you prefer

    $ docker build -t isgdocker/ansible-playbook:latest .

# Spin up nginx hello world servers
To spin it up, apply Terraform configuration:

    $ AWS_PROFILE=my-aws-profile-name terraform apply -auto-approve

## AWS creds
Export env variables `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` or `AWS_PROFILE`

# Destroy nginx hello world servers
Destroy is simple

    $ AWS_PROFILE=foobar terraform destroy -auto-approve

# Note
This is not for use in production as it opens ssh and
http port to the world; use it with caution.