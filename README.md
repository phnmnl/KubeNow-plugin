# PhenoMeNal plugin for KubeNow

This tutorial is designed to help users to set up a PhenoNeNal CRE on [Amazon](https://github.com/phnmnl/phenomenal-h2020/wiki/Deploy-on-Amazon-Web-Services), [Google Cloud](https://github.com/phnmnl/phenomenal-h2020/wiki/Deploy-on-Google-Cloud-Platform), [Microsoft Azure](https://github.com/phnmnl/phenomenal-h2020/wiki/Deploy-on-Microsoft-Azure) or in a public or private [OpenStack](https://github.com/phnmnl/phenomenal-h2020/wiki/Deploy--on-OpenStack) environment through the command-line: Special cases (private OpenStack, or for developers) when you want to use the infrastructure provisioning procedure without the web GUI. Alternatively, use the [PhenoMeNal portal](http://portal.phenomenal-h2020.eu) to launch a CRE on your preferred cloud provider.


## Prerequisites

The only prerequisite that need to be installed on your local machine is:
- [Docker](https://www.docker.com/) to run the container with all other dependencies (needed by kn command line client)

## Install KubeNow command line client that includes the PhenoMeNal plugin

    curl -f "https://raw.githubusercontent.com/kubenow/KubeNow/phenomenal/stable/bin/kn" -o "/tmp/kn"
    sudo mv /tmp/kn /usr/local/bin/
    sudo chmod +x /usr/local/bin/kn


Now follow the links below depending on your cloud provider:

[Deploy on Amazon Web Services](#deploy-on-amazon-web-services)

[Deploy on Google Cloud Platform](#deploy-on-google-cloud-platform)

[Deploy on Microsoft Azure](#deploy-on-microsoft-azure)

[Deploy on Openstack](#deploy-on-openstack)

[Deploy on Bare metal (KVM)](#deploy-on-bare-metal-kvm)

[Deploy on EGI Federated Cloud (OBS - BETA)](#deploy-on-egi-federated-cloud)


# Deploy on Amazon Web Services

This tutorial provides an overview of the steps involved in setting up a CRE on Amazon using command-line.

**Note**: Please follow [[Starting a PhenoMeNal CRE on a public or private cloud provider|Starting-a-PhenoMeNal-CRE-on-a-public-or-private-cloud-provider]] for the general prerequisites for a deployment on a private of public cloud provider.

## **Amazon specific prerequisites**

- You have an IAM user along with its *access key* and *security credentials* (http://docs.aws.amazon.com/IAM/latest/UserGuide/id_users_create.html)

## **Configuration**

All of the commands in this documentation are meant to be run in the config directory created by the command below.

Start by creating a configuration directory:

    kn --preset phenomenal init aws my-vre-config-dir
    cd my-vre-config-dir

Inside this configuration directory you will need to edit the file `config.tfvars` where you will need to set:

*Cluster*
- **`cluster_prefix`**: every resource in your tenancy will be named with this prefix

- **`aws_access_key_id`**: your access key id
- **`aws_secret_access_key`**: your secret access key id
- **`aws_region`**: the region where your cluster will be bootstrapped (e.g. ``eu-west-1``)
- **`availability_zone`**: an availability zone for your cluster (e.g. ``eu-west-1a``)

*Master configuration*
- **`master_instance_type`**: an instance flavor for the master
- **`master_as_edge`**: master is acting as gateway for accessing services

*Node configuration*
- **`node_count`**: number of Kubernetes nodes to be created (no floating IP is needed for these nodes)
- **`node_instance_type`**: an instance flavor name for the Kubernetes nodes

*Gluster configuration*
- **`glusternode_count`**: number of egde nodes to be created (1 - 3 depending on preferred replication factor)
- **`glusternode_instance_type`**: an instance flavor for the glusternodes
- **`glusternode_extra_disk_size`**: disk size of the fileserver size in GB

*Edge configuration (optional)*
- **`edge_count`**: number of egde nodes to be created
- **`edge_instance_type`**: an instance flavor for the edge nodes

*Cloudflare (optional)* - See: KubeNow [Cloudflare documentation.](http://kubenow.readthedocs.io/en/latest/getting_started/install-core.html#cloudflare-account-configuration)
- **`use_cloudflare`**: wether you want to use cloudflare as dns provider
- **`cloudflare_email`**: the mail that you used to register your Cloudflare account
- **`cloudflare_token`**: an authentication token that you can generate from the Cloudflare web interface
- **`cloudflare_domain`**: a zone that you created in your Cloudflare account. This typically matches your domain name (e.g. somedomain.com)

*Galaxy* - (In the `provision` sub-section of the config.tfvars config file)
- **`galaxy_admin_email`**: the local galaxy admin (you?)
- **`galaxy_admin_password`**: min 6 characters admin password

*Jupyter* - (In the `provision` sub-section of the config.tfvars config file)
In the provision-section of the config.tfvars config file
- **`jupyter_password`**: password for your notebook

*Kubernetes dashboard* - (In the `provision` sub-section of the config.tfvars config file)
In the provision-section of the config.tfvars config file
- **`dashboard_username`**: username to access your kubernetes dashboard
- **`dashboard_password`**: password for your kubernetes dashboard

*Pachyderm + Minio (optional)* - See: [Pachyderm tutorial with MTBLS data](https://github.com/phnmnl/MTBLS233-Pachyderm)
- **`pachyderm_release_name`**: a release name for the Pachyderm service
- **`pachyderm_etcd_pvc_size`**: storage dedicated for etcd (In GB)
- **`minio_release_name`**: release name for the Minio service
- **`minio_pvc_size`**: storage dedicated for the Minio service (In GB)
- **`minio_accesskey`**: access key for the S3 endpoint
- **`minio_secretkey`**: secret key for the S3 endpoint
- **`minio_replicas`**: number of replicas of the Minio service

**Once you are done with your settings you are ready to deploy the cluster:**

    kn apply

  when deployment is finished then you should be able to reach the services at:

    Galaxy         = http://galaxy.<your-prefix>.<yourdomain>
    Jupyter        = http://notebook.<your-prefix>.<yourdomain>
    Luigi          = http://luigi.<your-prefix>.<yourdomain>
    Kube-dashboard = http://dashboard.<your-prefix>.<yourdomain>
    Pachyderm      = ssh into the master node and use pachctl. Pachyderm tutorial: https://github.com/phnmnl/MTBLS233-Pachyderm

  and if you want to ssh into the master node:

    kn ssh

  and to destroy use:

    kn destroy

## PhenoMeNal help and support
[For feedback and help](http://phenomenal-h2020.eu/home/help/)

# Deploy on Google Cloud Platform

This tutorial provides an overview of the steps involved in setting up a CRE on Google cloud platform using command-line.

**Note**: Please follow [[Starting a PhenoMeNal CRE on a public or private cloud provider|Starting-a-PhenoMeNal-CRE-on-a-public-or-private-cloud-provider]] for the general prerequisites for a deployment on a private of public cloud provider.

## **Google cloud specific prerequisites**

 - You have enabled the Google Compute Engine API: API Manager > Library > Compute Engine API > Enable

 - You have created and downloaded a service account file for your GCE project: Api manager > Credentials > Create credentials > Service account key

## **Configuration**

All of the commands in this documentation are meant to be run in the config directory created by the command below.

Start by creating a configuration directory:

    kn --preset phenomenal init gce my-vre-config-dir
    cd my-vre-config-dir

Inside this configuration directory you will need to edit the file `config.tfvars` where you will need to set:

*Cluster*
- **`cluster_prefix`**: every resource in your tenancy will be named with this prefix

- **`gce_credentials_file`**: path to your service account file
- **`gce_region`**: the zone for your project (e.g. ``europe-west1-b``)
- **`gce_project`**: your project id

*Master configuration*
- **`master_flavor`**: an instance flavor for the master
- **`master_as_edge`**: master is acting as gateway for accessing services

*Node configuration*
- **`node_count`**: number of Kubernetes nodes to be created (no floating IP is needed for these nodes)
- **`node_flavor`**: an instance flavor name for the Kubernetes nodes

*Gluster configuration*
- **`glusternode_count`**: number of egde nodes to be created (1 - 3 depending on preferred replication factor)
- **`glusternode_flavor`**: an instance flavor for the glusternodes
- **`glusternode_extra_disk_size`**: disk size of the fileserver size in GB

*Edge configuration (optional)*
- **`edge_count`**: number of egde nodes to be created
- **`edge_iflavor`**: an instance flavor for the edge nodes

*Cloudflare (optional)* - See: KubeNow [Cloudflare documentation.](http://kubenow.readthedocs.io/en/latest/getting_started/install-core.html#cloudflare-account-configuration)
- **`use_cloudflare`**: wether you want to use cloudflare as dns provider
- **`cloudflare_email`**: the mail that you used to register your Cloudflare account
- **`cloudflare_token`**: an authentication token that you can generate from the Cloudflare web interface
- **`cloudflare_domain`**: a zone that you created in your Cloudflare account. This typically matches your domain name (e.g. somedomain.com)

*Galaxy* - (In the `provision` sub-section of the config.tfvars config file)
- **`galaxy_admin_email`**: the local galaxy admin (you?)
- **`galaxy_admin_password`**: min 6 characters admin password

*Jupyter* - (In the `provision` sub-section of the config.tfvars config file)
In the provision-section of the config.tfvars config file
- **`jupyter_password`**: password for your notebook

*Kubernetes dashboard* - (In the `provision` sub-section of the config.tfvars config file)
In the provision-section of the config.tfvars config file
- **`dashboard_username`**: username to access your kubernetes dashboard
- **`dashboard_password`**: password for your kubernetes dashboard

*Pachyderm + Minio (optional)* - See: [Pachyderm tutorial with MTBLS data](https://github.com/phnmnl/MTBLS233-Pachyderm)
- **`pachyderm_release_name`**: a release name for the Pachyderm service
- **`pachyderm_etcd_pvc_size`**: storage dedicated for etcd (In GB)
- **`minio_release_name`**: release name for the Minio service
- **`minio_pvc_size`**: storage dedicated for the Minio service (In GB)
- **`minio_accesskey`**: access key for the S3 endpoint
- **`minio_secretkey`**: secret key for the S3 endpoint
- **`minio_replicas`**: number of replicas of the Minio service

**Once you are done with your settings you are ready to deploy the cluster:**

    kn apply

  when deployment is finished then you should be able to reach the services at:

    Galaxy         = http://galaxy.<your-prefix>.<yourdomain>
    Jupyter        = http://notebook.<your-prefix>.<yourdomain>
    Luigi          = http://luigi.<your-prefix>.<yourdomain>
    Kube-dashboard = http://dashboard.<your-prefix>.<yourdomain>
    Pachyderm      = ssh into the master node and use pachctl. Pachyderm tutorial: https://github.com/phnmnl/MTBLS233-Pachyderm

  and if you want to ssh into the master node:

    kn ssh

  and to destroy use:

    kn destroy

## PhenoMeNal help and support
[For feedback and help](http://phenomenal-h2020.eu/home/help/)

# Deploy on Microsoft Azure

This tutorial provides an overview of the steps involved in setting up a CRE on Microsoft Azure using command-line.

**Note**: Please follow [[Starting a PhenoMeNal CRE on a public or private cloud provider|Starting-a-PhenoMeNal-CRE-on-a-public-or-private-cloud-provider]] for the general prerequisites for a deployment on a private of public cloud provider.

## **Azure specific prerequisites**

- You have created an application API key (Service Principal) in your Microsoft Azure subscription: (https://www.terraform.io/docs/providers/azurerm/authenticating_via_service_principal.html#creating-a-service-principal)

## **Configuration**

All of the commands in this documentation are meant to be run in the config directory created by the command below.

Start by creating a configuration directory:

    kn --preset phenomenal init azure my-vre-config-dir
    cd my-vre-config-dir

Inside this configuration directory you will need to edit the file `config.tfvars` where you will need to set:

*Cluster*
- **`cluster_prefix`**: every resource in your tenancy will be named with this prefix
- **`location`**: some Azure location (e.g. ``West Europe``)

- **`subscription_id`**: your subscription id
- **`client_id`**: your client id (also called appId)
- **`client_secret`**: your client secret (also called password)
- **`tenant_id`**: your tenant id

*Master configuration*
- **`master_vm_size`**: the vm size for the master (e.g. ``Standard_DS2_v2``) (e.g. ``Standard_DS2_v2``)
- **`master_as_edge`**:

*Node configuration*
- **`node_count`**: number of Kubernetes nodes to be created (no floating IP is needed for these nodes)
- **`node_vm_size`**: the vm size for the Kubernetes nodes (e.g. ``Standard_DS2_v2``)

*Gluster configuration*
- **`glusternode_count`**: number of egde nodes to be created (1 - 3 depending on preferred replication factor)
- **`glusternode_vm_size`**: the vm size for the glusternodes
- **`glusternode_extra_disk_size`**: disk size of the fileserver size in GB

*Edge configuration (optional)*
- **`edge_count`**: number of egde nodes to be created
- **`edge_vm_size`**: the vm size for the the edge nodes

*Cloudflare (optional)* - See: KubeNow [Cloudflare documentation.](http://kubenow.readthedocs.io/en/latest/getting_started/install-core.html#cloudflare-account-configuration)
- **`use_cloudflare`**: wether you want to use cloudflare as dns provider
- **`cloudflare_email`**: the mail that you used to register your Cloudflare account
- **`cloudflare_token`**: an authentication token that you can generate from the Cloudflare web interface
- **`cloudflare_domain`**: a zone that you created in your Cloudflare account. This typically matches your domain name (e.g. somedomain.com)

*Galaxy* - (In the `provision` sub-section of the config.tfvars config file)
- **`galaxy_admin_email`**: the local galaxy admin (you?)
- **`galaxy_admin_password`**: min 6 characters admin password

*Jupyter* - (In the `provision` sub-section of the config.tfvars config file)
In the provision-section of the config.tfvars config file
- **`jupyter_password`**: password for your notebook

*Kubernetes dashboard* - (In the `provision` sub-section of the config.tfvars config file)
In the provision-section of the config.tfvars config file
- **`dashboard_username`**: username to access your kubernetes dashboard
- **`dashboard_password`**: password for your kubernetes dashboard

*Pachyderm + Minio (optional)* - See: [Pachyderm tutorial with MTBLS data](https://github.com/phnmnl/MTBLS233-Pachyderm)
- **`pachyderm_release_name`**: a release name for the Pachyderm service
- **`pachyderm_etcd_pvc_size`**: storage dedicated for etcd (In GB)
- **`minio_release_name`**: release name for the Minio service
- **`minio_pvc_size`**: storage dedicated for the Minio service (In GB)
- **`minio_accesskey`**: access key for the S3 endpoint
- **`minio_secretkey`**: secret key for the S3 endpoint
- **`minio_replicas`**: number of replicas of the Minio service

**Once you are done with your settings you are ready to deploy the cluster:**

    kn apply

  when deployment is finished then you should be able to reach the services at:

    Galaxy         = http://galaxy.<your-prefix>.<yourdomain>
    Jupyter        = http://notebook.<your-prefix>.<yourdomain>
    Luigi          = http://luigi.<your-prefix>.<yourdomain>
    Kube-dashboard = http://dashboard.<your-prefix>.<yourdomain>
    Pachyderm      = ssh into the master node and use pachctl. Pachyderm tutorial: https://github.com/phnmnl/MTBLS233-Pachyderm

  and if you want to ssh into the master node:

    kn ssh

  and to destroy use:

    kn destroy

## PhenoMeNal help and support
[For feedback and help](http://phenomenal-h2020.eu/home/help/)


# Deploy on OpenStack

This tutorial provides an overview of the steps involved in setting up a CRE on Openstack using command-line.

**Note**: Please follow [[Starting a PhenoMeNal CRE on a public or private cloud provider|Starting-a-PhenoMeNal-CRE-on-a-public-or-private-cloud-provider]] for the general prerequisites for a deployment on a private of public cloud provider.

## **OpenStack specific prerequisites**

- You have downloaded the OpenStack RC file (credentials) for your tenancy: [How to download your credentials file](https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux_OpenStack_Platform/4/html/End_User_Guide/cli_openrc.html)

## **Configuration**

All of the commands in this documentation are meant to be run in the config directory created by the command below.

Start by creating a configuration directory:

    kn --preset phenomenal init openstack my-vre-config-dir
    cd my-vre-config-dir

Inside this configuration directory you will need to edit the file `config.tfvars` where you will need to set:

*Cluster*
- **`cluster_prefix`**: every resource in your tenancy will be named with this prefix

*Network*
- **`external_network_uuid`**: the uuid of the external network in the OpenStack tenancy - usually this is called `ext-net` or `public`, to find out you either look in your openstack web interface or via terminal command `neutron net-list`. [Here is the link to a detailed detailed guide of how to list networks in the KubeNow documentation](http://kubenow.readthedocs.io/en/stable/getting_started/bootstrap.html#bootstrap-kubernetes)
- **`floating_ip_pool`**: a floating IP pool name (this is usually the name of the external network, see parameter above)
- **`dns_nameservers`**: (optional, only needed if you want to use other dns-servers than default 8.8.8.8 and 8.8.4.4)

*Master configuration*
- **`master_flavor`**: an instance flavor for the master - [Here is the link to the detailed guide of how to list flavors in the KubeNow documentation](http://kubenow.readthedocs.io/en/stable/getting_started/bootstrap.html#bootstrap-kubernetes) of how to list and find available flavors in your OpenStack teenancy.
- **`master_as_edge`**: master is acting as gateway for accessing services

*Node configuration*
- **`node_count`**: number of Kubernetes nodes to be created (no floating IP is needed for these nodes)
- **`node_flavor`**: an instance flavor name for the Kubernetes nodes

*Gluster configuration*
- **`glusternode_count`**: number of egde nodes to be created (1 - 3 depending on preferred replication factor)
- **`glusternode_flavor`**: an instance flavor for the glusternodes
- **`glusternode_extra_disk_size`**: disk size of the fileserver size in GB

*Edge configuration (optional)*
- **`edge_count`**: number of egde nodes to be created
- **`edge_flavor`**: an instance flavor for the edge nodes

*Cloudflare (optional)* - See: KubeNow [Cloudflare documentation.](http://kubenow.readthedocs.io/en/latest/getting_started/install-core.html#cloudflare-account-configuration)
- **`use_cloudflare`**: wether you want to use cloudflare as dns provider
- **`cloudflare_email`**: the mail that you used to register your Cloudflare account
- **`cloudflare_token`**: an authentication token that you can generate from the Cloudflare web interface
- **`cloudflare_domain`**: a zone that you created in your Cloudflare account. This typically matches your domain name (e.g. somedomain.com)

*Galaxy* - (In the `provision` sub-section of the config.tfvars config file)
- **`galaxy_admin_email`**: the local galaxy admin (you?)
- **`galaxy_admin_password`**: min 6 characters admin password

*Jupyter* - (In the `provision` sub-section of the config.tfvars config file)
In the provision-section of the config.tfvars config file
- **`jupyter_password`**: password for your notebook

*Kubernetes dashboard* - (In the `provision` sub-section of the config.tfvars config file)
In the provision-section of the config.tfvars config file
- **`dashboard_username`**: username to access your kubernetes dashboard
- **`dashboard_password`**: password for your kubernetes dashboard

*Pachyderm + Minio (optional)* - See: [Pachyderm tutorial with MTBLS data](https://github.com/phnmnl/MTBLS233-Pachyderm)
- **`pachyderm_release_name`**: a release name for the Pachyderm service
- **`pachyderm_etcd_pvc_size`**: storage dedicated for etcd (In GB)
- **`minio_release_name`**: release name for the Minio service
- **`minio_pvc_size`**: storage dedicated for the Minio service (In GB)
- **`minio_accesskey`**: access key for the S3 endpoint
- **`minio_secretkey`**: secret key for the S3 endpoint
- **`minio_replicas`**: number of replicas of the Minio service

**Once you are done with your settings you are ready to deploy the cluster:**

    kn apply

  when deployment is finished then you should be able to reach the services at:

    Galaxy         = http://galaxy.<your-prefix>.<yourdomain>
    Jupyter        = http://notebook.<your-prefix>.<yourdomain>
    Luigi          = http://luigi.<your-prefix>.<yourdomain>
    Kube-dashboard = http://dashboard.<your-prefix>.<yourdomain>
    Pachyderm      = ssh into the master node and use pachctl. Pachyderm tutorial: https://github.com/phnmnl/MTBLS233-Pachyderm

  and if you want to ssh into the master node:

    kn ssh

  and to destroy use:

    kn destroy

# PhenoMeNal help and support
[For feedback and help](http://phenomenal-h2020.eu/home/help/)


# Deploy on Bare metal (KVM)

This tutorial provides an overview of the steps involved in setting up a CRE on a local server (bare metal) using command-line.

**Note**: Please follow [Starting a PhenoMeNal CRE on a public or private cloud provider|(Starting-a-PhenoMeNal-CRE-on-a-public-or-private-cloud-provider) for the general prerequisites for a deployment on a private of public cloud provider.

## **Server specific prerequisites**

- You have a Linux server (tested on Ubuntu 16.04 and Centos 7) with [KVM](https://www.linux-kvm.org/page/Main_Page) and [libvirt](https://libvirt.org/) installed.

## **Configuration**

All of the commands in this documentation are meant to be run in the config directory created by the command below.

Start by creating a configuration directory:

    kn --preset phenomenal init kvm my-vre-config-dir
    cd my-vre-config-dir

Inside this configuration directory you will need to edit the file `config.tfvars` where you will need to set:

*Cluster*
- **`cluster_prefix`**: every resource in your tenancy will be named with this prefix

*Master configuration*
- **`master_as_edge`**: master is acting as gateway for accessing services
- **`master_vcpu`**: number of virtual cpu:s to assign
- **`master_memory`**: size of memory to assign (in Megabyte, MB)

*Storage configuration*
- **`master_extra_disk_size`**: an extra virtual disk image is created and attached to VM as storage for PhenoMenal services

*Cloudflare (optional)* - See: KubeNow [Cloudflare documentation.](http://kubenow.readthedocs.io/en/latest/getting_started/install-core.html#cloudflare-account-configuration)
- **`use_cloudflare`**: wether you want to use cloudflare as dns provider
- **`cloudflare_email`**: the mail that you used to register your Cloudflare account
- **`cloudflare_token`**: an authentication token that you can generate from the Cloudflare web interface
- **`cloudflare_domain`**: a zone that you created in your Cloudflare account. This typically matches your domain name (e.g. somedomain.com)

*Galaxy* - (In the `provision` sub-section of the config.tfvars config file)
- **`galaxy_admin_email`**: the local galaxy admin (you?)
- **`galaxy_admin_password`**: min 6 characters admin password

*Jupyter* - (In the `provision` sub-section of the config.tfvars config file)
In the provision-section of the config.tfvars config file
- **`jupyter_password`**: password for your notebook

*Kubernetes dashboard* - (In the `provision` sub-section of the config.tfvars config file)
In the provision-section of the config.tfvars config file
- **`dashboard_username`**: username to access your kubernetes dashboard
- **`dashboard_password`**: password for your kubernetes dashboard


**Once you are done with your settings you are ready to deploy the cluster:**

    kn apply

  when deployment is finished then you should be able to reach the services at:

    Galaxy         = http://galaxy.<your-prefix>.<yourdomain>
    Jupyter        = http://notebook.<your-prefix>.<yourdomain>
    Luigi          = http://luigi.<your-prefix>.<yourdomain>
    Kube-dashboard = http://dashboard.<your-prefix>.<yourdomain>


  and if you want to ssh into the master node:

    kn ssh

  and to destroy use:

    kn destroy
    
# Deploy on EGI Federated Cloud

This tutorial provides an overview of the steps involved in setting up a CRE on EGI Federated Cloud using command-line.

**Note**: Please follow [Prerequisites and installing the kn-client|(#prerequisites) for the general prerequisites for a deployment on a private of public cloud provider.

## **EGI Federated Cloud specific prerequisites**

Start by creating an openstack configuration directory:
    
    kn --preset phenomenal init openstack my-vre-config-dir
    cd my-vre-config-dir

Create a dir for voms-proxy-configuration

    mkdir voms-config

Copy your voms-proxy-certificate created at https://elixir-cilogon-mp.grid.cesnet.cz/vo-portal/

    cp your-cert voms-config/voms-proxy-cert

Init your voms config with the cloud provider you want

    kn voms-config "vo.elixir-europe.org" "https://sbgcloud.in2p3.fr:5000/v2.0"

Export variables as described in output from previous 'kn voms-config' command

e.g.

     export OS_AUTH.....
     export OS_X509.....


## **Configuration**

All of the commands in this documentation are meant to be run in the config directory created above.

Inside this configuration directory you will need to edit the file `config.tfvars` where you will need to set:

*Boot Image* (At the end of the config file you need to edit this)
- **`boot_image`**: this need to be changed into "Image for KubeNow [Ubuntu/16.04/QEMU-KVM]"

*Cluster*
- **`cluster_prefix`**: every resource in your tenancy will be named with this prefix

*Network*

To list available networks you can use command `kn openstack network list`

- **`external_network_uuid`**: the uuid of the external network in the OpenStack tenancy - usually this is called `ext-net` or `public`, to find out you either look in your openstack web interface or via terminal command `neutron net-list`. [Here is the link to a detailed detailed guide of how to list networks in the KubeNow documentation](http://kubenow.readthedocs.io/en/stable/getting_started/bootstrap.html#bootstrap-kubernetes)
- **`floating_ip_pool`**: a floating IP pool name (this is usually the name of the external network, see parameter above)
- **`dns_nameservers`**: (optional, only needed if you want to use other dns-servers than default 8.8.8.8 and 8.8.4.4)

*Master configuration*

To list available flavors you can use command `kn openstack flavor list`

- **`master_flavor`**: an instance flavor for the master - [Here is the link to the detailed guide of how to list flavors in the KubeNow documentation](http://kubenow.readthedocs.io/en/stable/getting_started/bootstrap.html#bootstrap-kubernetes) of how to list and find available flavors in your OpenStack teenancy.
- **`master_as_edge`**: master is acting as gateway for accessing services

*Node configuration*
- **`node_count`**: number of Kubernetes nodes to be created (no floating IP is needed for these nodes)
- **`node_flavor`**: an instance flavor name for the Kubernetes nodes

*Gluster configuration*
- **`glusternode_count`**: number of egde nodes to be created (1 - 3 depending on preferred replication factor)
- **`glusternode_flavor`**: an instance flavor for the glusternodes
- **`glusternode_extra_disk_size`**: disk size of the fileserver size in GB

*Edge configuration (optional)*
- **`edge_count`**: number of egde nodes to be created
- **`edge_flavor`**: an instance flavor for the edge nodes

*Cloudflare (optional)* - See: KubeNow [Cloudflare documentation.](http://kubenow.readthedocs.io/en/latest/getting_started/install-core.html#cloudflare-account-configuration)
- **`use_cloudflare`**: wether you want to use cloudflare as dns provider
- **`cloudflare_email`**: the mail that you used to register your Cloudflare account
- **`cloudflare_token`**: an authentication token that you can generate from the Cloudflare web interface
- **`cloudflare_domain`**: a zone that you created in your Cloudflare account. This typically matches your domain name (e.g. somedomain.com)

*Galaxy* - (In the `provision` sub-section of the config.tfvars config file)
- **`galaxy_admin_email`**: the local galaxy admin (you?)
- **`galaxy_admin_password`**: min 6 characters admin password

*Jupyter* - (In the `provision` sub-section of the config.tfvars config file)
In the provision-section of the config.tfvars config file
- **`jupyter_password`**: password for your notebook

*Kubernetes dashboard* - (In the `provision` sub-section of the config.tfvars config file)
In the provision-section of the config.tfvars config file
- **`dashboard_username`**: username to access your kubernetes dashboard
- **`dashboard_password`**: password for your kubernetes dashboard

*Pachyderm + Minio (optional)* - See: [Pachyderm tutorial with MTBLS data](https://github.com/phnmnl/MTBLS233-Pachyderm)
- **`pachyderm_release_name`**: a release name for the Pachyderm service
- **`pachyderm_etcd_pvc_size`**: storage dedicated for etcd (In GB)
- **`minio_release_name`**: release name for the Minio service
- **`minio_pvc_size`**: storage dedicated for the Minio service (In GB)
- **`minio_accesskey`**: access key for the S3 endpoint
- **`minio_secretkey`**: secret key for the S3 endpoint
- **`minio_replicas`**: number of replicas of the Minio service

**Once you are done with your settings you are ready to deploy the cluster:**

    kn apply

  when deployment is finished then you should be able to reach the services at:

    Galaxy         = http://galaxy.<your-prefix>.<yourdomain>
    Jupyter        = http://notebook.<your-prefix>.<yourdomain>
    Luigi          = http://luigi.<your-prefix>.<yourdomain>
    Kube-dashboard = http://dashboard.<your-prefix>.<yourdomain>
    Pachyderm      = ssh into the master node and use pachctl. Pachyderm tutorial: https://github.com/phnmnl/MTBLS233-Pachyderm

  and if you want to ssh into the master node:

    kn ssh

  and to destroy use:

    kn destroy

## PhenoMeNal help and support
[For feedback and help](http://phenomenal-h2020.eu/home/help/)
