# MEDIAWIKI PROBLEM STATEMENT

[![N|Solid](https://www.terraform.io/assets/images/logo-text-8c3ba8a6.svg)](https://www.terraform.io/)

All the Code used and written in this repo are solely written by me and used all the opensoruce tools like Terraform and Ansible for IAAC and SCM

# Problem Statement
The problem statement was to build a complete End to End deployment of [MEDIAWIKI][df1] app with Infrastructure Up and Running and Software Configuration Integrated with on the fly.

>  ### Terraform or any IaC tool with any Configuration Management tool integrated.

---

# Approach

The approach to solve the above problem was to use the most common IAAC tool `Terraform` with `Ansible` on top of it to setup infra and setup necessary utilities to make the application up and running

### Tool Used

* Terraform
* Ansible

# Installation

### Install Terraform

To install Terraform, find the [appropriate package][d] for your system and download it as a zip archive.

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

To install Ansible, find the [appropriate flavour][d2] for your system

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
- `config` directory contains all the common application that require configuration. Mediawiki is running `ngninx` as a web-server and `php-fpm` as downstream server. The nginx-conf is copied from local to private app server from `config` directory

# Launch
To get up and running follow the below to launch your application `mediawiki` and the complete end to end infra setup

## Git clone


1. Clone the following Repo

```
git clone https://github.com/YashDevops/Assignment

cd Assignment/projects/prod/assignment
```

2. Edit the provider.tf

- change  the following line and add `{user-name}` with your username
- change `{profile}` with your aws profile with all the access to allow run this terraform code

```
provider "aws" {
  region = "us-east-1"
  shared_credentials_file = "/Users/{user-name}/.aws/creds"    ## {user-name} : Replace it with your username to allow access to aws credentials files
  profile                 = "{profile}"                        ## {profile} : Enter the profile that you want to use. By Default the profile is : default
}
```

3. Run the following command to run the `terraform` code

```
terraform init

terraform plan -var 'Name=mediawiki' -var 'Team=infra-team' -var 'Project=Mediawiki-Project'       #it will produce you all the resource that it is going to create

terraform apply -var 'Name=mediawiki' -var 'Team=infra-team' -var 'Project=Mediawiki-Project' -auto-approve


```
