from centos:centos7

MAINTAINER Anoop A K <anoop@codecg.com> 

# Install postgresql-libs
RUN yum install wget postgresql-libs tar -y

# Copy afanasy RPMs to /tmp
WORKDIR /tmp
RUN wget https://sourceforge.net/projects/cgru/files/2.3.0/cgru.2.3.0.CentOS-7.5.1804_x86_64.tar.gz

# Extract the archive to /tmp
RUN tar xfv cgru.2.3.0.CentOS-7.5.1804_x86_64.tar.gz -C /tmp/

# Install Dependencies
RUN yum install postgresql-libs -y

# Install afanasy-server
RUN yum install cgru-common-2.3.0-0.x86_64.rpm -y
RUN yum install afanasy-common-2.3.0-0.x86_64.rpm -y
RUN yum install afanasy-server-2.3.0-0.x86_64.rpm -y

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
