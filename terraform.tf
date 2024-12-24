terraform {
  cloud {

    organization = "ZeroCloud"

    workspaces {
      name = "Public-Load-Balancer-to-Private-EC2-Instances"
    }
  }
}
