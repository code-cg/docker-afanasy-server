from centos:centos6

MAINTAINER Anoop A K <anoop@codecg.com> 

# Install postgresql-libs
RUN yum install postgresql-libs tar -y

# Copy afanasy RPMs to /tmp
ADD http://downloads.sourceforge.net/project/cgru/2.1.0/cgru.2.1.0.CentOS-6.7_x86_64.tar.gz /tmp/ 

# Extract the archive to /tmp
RUN tar xfv  /tmp/cgru.2.1.0.CentOS-6.7_x86_64.tar.gz -C /tmp/ 

# Install afanasy-server
RUN rpm -ivh /tmp/cgru-common-2.1.0-0.x86_64.rpm
RUN rpm -ivh /tmp/afanasy-common-2.1.0-0.x86_64.rpm 
RUN rpm -ivh /tmp/afanasy-server-2.1.0-0.x86_64.rpm

# Set CGRU environment variables
ENV PATH /opt/cgru/afanasy/bin:$PATH
ENV CGRU_LOCATION /opt/cgru
ENV AF_ROOT /opt/cgru/afanasy
ENV PYTHONPATH /opt/cgru/lib/python:/opt/cgru/afanasy/python:$PYTHONPATH

# Copy the default configuration file to AF_ROOT
COPY config_default.json /opt/cgru/afanasy/config_default.json

# Add entrypoint for resetting database
COPY ./db_reset_all.sh /
RUN chmod +x /db_reset_all.sh

ENTRYPOINT ["/db_reset_all.sh"]

EXPOSE 51000
CMD = ["afserver"]
