# AppScale AWS deployment

Templates for AppScale deployments on AWS.

* `appscale-environment` : VPC for appscale deployments
  * `appscale-bastion-resources` : Longer lived resources for bastion host
    * `appscale-bastion` : Bastion host for access to deployments
  * `appscale-public-deployment` : Public subnet for single-host demo deployments
  * `appscale-deployment-nat` : NAT gateway for use by private subnet deployments
    * `appscale-deployment` : Private subnet for deployments

