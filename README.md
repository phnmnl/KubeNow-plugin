# PhenoMeNal plugin for KubeNow

This tutorial is designed to help users to set up a PhenoNeNal CRE on [Amazon](https://github.com/phnmnl/phenomenal-h2020/wiki/Deploy-on-Amazon-Web-Services), [Google Cloud](https://github.com/phnmnl/phenomenal-h2020/wiki/Deploy-on-Google-Cloud-Platform), [Microsoft Azure](https://github.com/phnmnl/phenomenal-h2020/wiki/Deploy-on-Microsoft-Azure) or in a public or private [OpenStack](https://github.com/phnmnl/phenomenal-h2020/wiki/Deploy--on-OpenStack) environment through the command-line: Special cases (private OpenStack, or for developers) when you want to use the infrastructure provisioning procedure without the web GUI. Alternatively, use the [PhenoMeNal portal](http://portal.phenomenal-h2020.eu) to launch a CRE on your preferred cloud provider.

## Prerequisites

The only prerequisite that need to be installed on your local machine is:
- [Docker](https://www.docker.com/) to run the container with all other dependencies (needed by kn command line client)

## Install KubeNow command line client that includes the PhenoMeNal plugin

    curl -f "https://raw.githubusercontent.com/kubenow/KubeNow/feature/phenomenal-kn/bin/kn" -o "/tmp/kn"
    sudo mv /tmp/kn /usr/local/bin/
    sudo chmod +x /usr/local/bin/kn


Now follow the links below depending on your cloud provider:

[Deploy on Amazon Web Services]

[Deploy on Google Cloud Platform]

[Deploy on Microsoft Azure]

[Deploy on Openstack]

[Deploy on Bare metal (KVM)]


# OpenStack

This tutorial provides an overview of the steps involved in setting up a CRE on Openstack using command-line.

## **OpenStack specific prerequisites**

- You have downloaded the OpenStack RC file (credentials) for your tenancy: [How to download your credentials file](https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux_OpenStack_Platform/4/html/End_User_Guide/cli_openrc.html)

## **Configuration**

All of the commands in this documentation are meant to be run in the config directory created by the command below.

Start by creating a configuration directory:

    kn --preset phenomenal init openstack my-openstac-config-dir
    cd my-openstac-config-dir

Inside this configuration directory you will need to edit the file `config.tfvars` where you will need to set:

*Cluster*

- **`cluster_prefix`**: every resource in your tenancy will be named with this prefix

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

*Pachyderm + Minio (optional)*
- **`pachyderm_release_name`**: a release name for the Pachyderm service
- **`pachyderm_etcd_pvc_size`**: storage dedicated for etcd (In GB)
- **`minio_release_name`**: release name for the Minio service
- **`minio_pvc_size`**: storage dedicated for the Minio service (In GB)
- **`minio_accesskey`**: access key for the S3 endpoint
- **`minio_secretkey`**: secret key for the S3 endpoint
- **`minio_replicas`**: number of replicas of the Minio service

**Once you are done with your settings you are ready to deploy the cluster:**

Now you need to source your openstack-rc-credentials file:

    source /path/to/openstack/credentials

And then create the VRE:

    kn apply

  when deployment is finished then you should be able to reach the services at:

    Galaxy         = http://galaxy.<your-prefix>.<yourdomain>
    Jupyter        = http://notebook.<your-prefix>.<yourdomain>
    Luigi          = http://luigi.<your-prefix>.<yourdomain>
    Kube-dashboard = http://dashboard.<your-prefix>.<yourdomain>
    Pachyderm      = ssh into the master node and install patchctl:

    curl -o /tmp/pachctl.deb -L https://github.com/pachyderm/pachyderm/releases/download/v1.6.6/pachctl_1.6.6_amd64.deb && sudo dpkg -i /tmp/pachctl.deb

  Please note that the `pachctl` version should correspond with the pachd service version. For more information please consult: http://pachyderm.readthedocs.io/en/latest/index.html. You can see an example on how to create pipelines here: https://github.com/pharmbio/MTBLS233-Pachyderm


  and if you want to ssh into the master node:

    kn ssh

  and to destroy use:

    kn destroy

# PhenoMeNal help and support
[For feedback and help](http://phenomenal-h2020.eu/home/help/)





