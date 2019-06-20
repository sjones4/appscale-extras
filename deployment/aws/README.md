# AppScale AWS deployment

Templates for AppScale deployments on AWS.

* `appscale-environment` : VPC for appscale deployments
  * `appscale-bastion-resources` : Longer lived resources for bastion host
    * `appscale-bastion` : Bastion host for access to deployments
  * `appscale-cloudstorage-environment` : Environment for cloud storage (buckets, repositories, iam resources, etc)
    * `appscale-cloudstorage-ecr-init` : Load cloud storage images to respositories (stack can be removed after load)
    * `appscale-cloudstorage` : AppScale cloud storage deployment
  * `appscale-public-deployment` : Public subnet for single-host demo deployments
  * `appscale-deployment-nat` : NAT gateway for use by private subnet deployments
    * `appscale-deployment` : Private subnet for deployments

