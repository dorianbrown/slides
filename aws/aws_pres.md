# Working with AWS

![](aws.png)

---
## Why cloud computing

- Amazon bought servers to handle peak load times (christmas, valentines day, etc)
- On average, 90% of there servers weren't being used

---
# Hello Jupyter!

<img src="hello_world2.jpg" style="width: 35%">

A quick demo on creating an AWS instance with a jupyter lab/notebook session

- AWS web console
- Creating and connecting to instance
- AMI's

---
# Costs

> Instances cost money according to how much they are used

The costs consist of:
- Computation depending on instance (time used)
- Storage (time used)
- Fixed IP (changes by default on restart)

Overview of costs on [AWS website](https://aws.amazon.com/ec2/pricing/)

---
# Adding Users

You have two kinds of users
- Web console users
- Instance users

---
# SSH

- Default PEM key/user
- Creating new users and ssh keys

---
# Lambda functions

> **Lambda functions: ** Let you run code to manage servers

We configured a lambda function to kill servers not on white-list

---
# Use Cases

Some common use-cases within ING:
- **Trainings**: create copies for each training participant
- **Prototyping with open-source data**
- **Creating applications which need internet connectivity** (webscoring, TTD)
