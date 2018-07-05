# PhenoMeNal plugin for KubeNow

This tutorial is designed to help users to set up a PhenoNeNal CRE on [Amazon](https://github.com/phnmnl/phenomenal-h2020/wiki/Deploy-on-Amazon-Web-Services), [Google Cloud](https://github.com/phnmnl/phenomenal-h2020/wiki/Deploy-on-Google-Cloud-Platform), [Microsoft Azure](https://github.com/phnmnl/phenomenal-h2020/wiki/Deploy-on-Microsoft-Azure) or in a public or private [OpenStack](https://github.com/phnmnl/phenomenal-h2020/wiki/Deploy--on-OpenStack) environment through the command-line when you want to use the infrastructure provisioning procedure without the web GUI. Alternatively, use the [PhenoMeNal portal](http://portal.phenomenal-h2020.eu) to launch a CRE on your preferred cloud provider.

## Prerequisites

The only prerequisite that need to be installed on your local machine is:
- [Docker](https://www.docker.com/) to run the container with all other dependencies (needed by kn command line client)

## Install KubeNow command line client that includes the PhenoMeNal plugin

    curl -f "https://raw.githubusercontent.com/kubenow/KubeNow/phenomenal/stable/bin/kn" -o "/tmp/kn"
    sudo mv /tmp/kn /usr/local/bin/
    sudo chmod +x /usr/local/bin/kn

Now follow the links below depending on your cloud provider:

[Deploy on Amazon Web Services](https://github.com/phnmnl/phenomenal-h2020/wiki/Deploy-on-Amazon-Web-Services)

[Deploy on Google Cloud Platform](https://github.com/phnmnl/phenomenal-h2020/wiki/Deploy-on-Google-Cloud-Platform)

[Deploy on Microsoft Azure](https://github.com/phnmnl/phenomenal-h2020/wiki/Deploy-on-Microsoft-Azure)

[Deploy on Openstack](https://github.com/phnmnl/phenomenal-h2020/wiki/Deploy-on-OpenStack)

[Deploy on Bare metal (KVM)](https://github.com/phnmnl/phenomenal-h2020/wiki/Deploy-on-a-local-server-(bare-metal))

[Deploy on EGI Federated Cloud](https://github.com/phnmnl/phenomenal-h2020/wiki/Deploy-on-European-Open-Science-Cloud-(EOSC))
