packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.2"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "myami" {
  ami_name      = "learn-packer-linux-aws"
  instance_type = "t2.micro"
  region        = "us-east-2"
  source_ami    = "ami-00399ec92321828f5 "
  ssh_username  = "ubuntu"
}

build {
  sources = [
    "source.amazon-ebs.myami"
  ]
  provisioner "shell" {
    inline = [
      "sleep 30",
      "sudo apt-get update && sudo apt-get upgrade -y",
      "sudo apt-get install libtomcat9-java -y",
      "sudo apt-get update -y",
      "sudo apt-get install tomcat9-admin tomcat9-common -y",
      "sudo apt-get install tomcat9 -y",
      "cd /var/lib/tomcat9/webapps/",
      "sudo wget https://app-ion-dev-bucket-us-east-2.s3.us-east-2.amazonaws.com/iris.war",
      "sudo systemctl start tomcat9"
     ]
  }
}
