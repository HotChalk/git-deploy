name             "git-deploy"
maintainer       "Edify Software Consulting"
maintainer_email "cookbooks@edify.cr"
license          "Apache 2.0"
description      "Installs/Configures git-deploy"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.1.0"

depends "sudo", ">= 2.1.2"
depends "users", ">= 1.5.0"

supports "ubuntu"
