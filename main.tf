terraform {
  cloud {
    organization = "VEERAS"

    workspaces {
      name = "myfirstworkspace"
    }
  }
}

variable "aws_region" {
    default = "ap-south-1"
}

provider "aws" {
    region = "us-east-2"
}
provider "aws" {
    region = "ap-south-1"
    alias = "india"
}

variable "server_names"{
    type = list(string)
    default = ["veera1", "veera2"]
}

variable "server_namesmap"{
    type = map(string)
    default = {
        servername = "veera1"
        servername = "veera2"
}
}

resource "aws_instance" "moduleinstance" {
    for_each = toset(var.server_names)
    ami ="ami-0603cbe34fd08cb81"
    instance_type = "t2.micro"
    tags = {
        Name = each.value
    }
}

resource "aws_instance" "moduleinstance1" {
    count = 2
    ami ="ami-0603cbe34fd08cb81"
    instance_type = "t2.micro"
    tags = {
        Name = "veera-${count.index}"
    }
}

locals {
     myName = "veera"
     myvpcs = toset (["vpc1", "vpc2"])
}

output "IPlist" {
    value = aws_instance.moduleinstance1.0.private_ip
}


resource "aws_instance" "instancemap" {
    for_each = var.server_namesmap
    ami ="ami-0603cbe34fd08cb81"
    instance_type = "t2.micro"
    tags = {
        Name = each.value
    }
}

resource "aws_s3_bucket" "bucket"{
    bucket = var.bucket_name
    provider = aws.india
    tags = {
        name = var.name
        dept = var.dept
    }
}

output "bucket_arn" {
    value = aws_s3_bucket.bucket.arn
}

output "bucket_name" {
    value = aws_s3_bucket.bucket.name
}
