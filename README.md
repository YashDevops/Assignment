# MEDIAWIKI PROBLEM STATEMENT

[![N|Solid](https://www.terraform.io/assets/images/logo-text-8c3ba8a6.svg)](https://www.terraform.io/)

All the Code used and written in this repo are solely written by me and used all the opensoruce tools like Terraform and Ansible for IAAC and SCM

# Problem Statement
The problem statement was to build a complete End to End deployment of [MEDIAWIKI](https://www.mediawiki.org/wiki/MediaWiki) app with Infrastructure Up and Running and Software Configuration Integrated with it on the fly.

>  ### Terraform or any IaC tool with any Configuration Management tool integrated.

---

# Approach

The approach to solve the above problem was to use the most common IAAC tool `Terraform` with `Ansible` on top of it to setup infra and setup necessary utilities to make the application up and running

### Tool Used

* Terraform
* Ansible

# Installation

### Install Terraform

To install Terraform, find the [appropriate package](https://www.terraform.io/downloads.html) for your system and download it as a zip archive.

After downloading Terraform, unzip the package. Terraform runs as a single binary named `terraform`. Any other files in the package can be safely removed and Terraform will still function.

Finally, make sure that the `terraform` binary is available on your `PATH`. This process will differ depending on your operating system.

Print a colon-separated list of locations in your `PATH`.
```
    $ echo $PATH
```

Move the Terraform binary to one of the listed locations. This command assumes that the binary is currently in your downloads folder and that your `PATH` includes `/usr/local/bin`, but you can customize it if your locations are different.

```
$ mv ~/Downloads/terraform /usr/local/bin/
```

### Install Ansible

To install Ansible, find the [appropriate flavour](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html) for your system

```
$ sudo apt update
$ sudo apt install software-properties-common
$ sudo apt-add-repository --yes --update ppa:ansible/ansible
$ sudo apt install ansible
```


#### Directory Structure of Assignment

After Cloning the  directory this will look something like this :-

![Image of Assignment tree](https://github.com/YashDevops/Assignment/blob/master/img/tree-Assignment-Dir.png)


- All  the modules are under `modules` directory
- Every `env` | `prod` or `dev` is inside the project directory. Currently prod has the our project `assignment`
- All the Ansible related code is inside the `Ansible` Directory
- `Ansible` Directory contains `roles` and `Mediawiki`. Roles are common roles which are used in the project `Mediawiki` and the dynaminc values are passed on to it via folder `group_vars`
- `keys` are normal which will be used by the `terraform` code to push public key in all the instances lauched to maintain `ssh` accessibility
- `config` directory contains all the common application that require configuration. Mediawiki is running `nginx` as a web-server and `php-fpm` as downstream server. The nginx-conf is copied from local to private app server from `config` directory

# :rocket: Launch
To get App up and running follow the below to launch your application `mediawiki` and the complete end to end infra setup

## Git clone


1. Clone the following Repo

```
git clone https://github.com/YashDevops/Assignment

cd Assignment/projects/prod/assignment
```

2. Edit the `provider.tf`

- change  the following line and add `{user-name}` with your username
- change `{profile}` with your aws profile with all the access to allow run this terraform code

```
provider "aws" {
  region = "us-east-1"
  shared_credentials_file = "/Users/{user-name}/.aws/credentials"    ## {user-name} : Replace it with your username and path with your to allow access to aws credentials files
  profile                 = "{profile}"                        ## {profile} : Enter the profile that you want to use. By Default the profile is : default
}
```

3. Get the `canonical Id` for your account

Run the following Command and you will get the canonical Id for you account for the `data` in `terraform` to fetch `ami` with respective filters

```
aws ec2 describe-images --filters "Name=name,Values=ubuntu/images/hvm-ssd/ubuntu-bionic-18.04*"  --query 'Images[*].{CanonicalID:OwnerId, N:Name}' | head -n6
```

The output will looks something like this

![Image of canonical_id](https://github.com/YashDevops/Assignment/blob/master/img/canonical-id-getter.png)


4. Run the following command to run the `terraform` code

```
terraform init

terraform plan -var 'Name=mediawiki' -var 'Team=infra-team' -var 'Project=Mediawiki-Project'   -var 'account_id={canonical_id}'    #get the canonical_id from step 3

terraform apply -var 'Name=mediawiki' -var 'Team=infra-team' -var 'Project=Mediawiki-Project' -var 'account_id={canonical_id}' -auto-approve


```

The following variable pass on with the commands are for the Tagging purpose of the complete project. There is another variable called `{canonical_id}` you can substitute it with the `canonical id` of your account which you can get via `step3`


## :warning: Terraform `Data` Error

if you get an error like this while deploying

```

null_resource.cluster: Still creating... [4m30s elapsed]
null_resource.cluster (remote-exec): changed: [X.X.X.X]

null_resource.cluster (remote-exec): TASK [../../roles/MediaWiki : Changing Zip for naming convention] **************
null_resource.cluster (remote-exec): changed: [X.X.X.X]

null_resource.cluster (remote-exec): TASK [../../roles/service : Restart service nginx, in all cases] ***************
null_resource.cluster (remote-exec): changed: [X.X.X.X]

null_resource.cluster (remote-exec): PLAY RECAP *********************************************************************
null_resource.cluster (remote-exec): X.X.X.X                 : ok=12   changed=11   unreachable=0    failed=0


data.aws_subnet_ids.subnet: Still reading... [5m30s elapsed]
null_resource.cluster: Still creating... [4m40s elapsed]
data.aws_subnet_ids.subnet: Still reading... [5m40s elapsed]
null_resource.cluster: Still creating... [4m50s elapsed]
data.aws_subnet_ids.subnet: Still reading... [5m50s elapsed]
null_resource.cluster: Still creating... [5m0s elapsed]
data.aws_subnet_ids.subnet: Still reading... [6m0s elapsed]
null_resource.cluster: Still creating... [5m10s elapsed]
data.aws_subnet_ids.subnet: Still reading... [6m10s elapsed]
null_resource.cluster: Still creating... [5m20s elapsed]
data.aws_subnet_ids.subnet: Still reading... [6m20s elapsed]
null_resource.cluster: Still creating... [5m30s elapsed]
null_resource.cluster: Creation complete after 5m33s [id=82195849465397240]

Error: no matching subnet found for vpc with id vpc-xxxxxxxxxxxxxxxxxxxxxxx
```

Its a `small issue` with `data` , It is not able to find all the `public subnet` to launch the `load_balancer` kindly rerun the `terraform apply` apply again and it will get resolve.

:exclamation: Bugs

This issue in `data`, [ not able to fetch public subnet ids ] this can be solved by adding retry in data feature. A `issue` is already open in the `terraform-aws-plugin` repo under the link [Data-Retry-Issue-Link](https://github.com/terraform-providers/terraform-provider-aws/issues/11342)
