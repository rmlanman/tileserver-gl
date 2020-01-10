FROM registry.access.redhat.com/ubi8
MAINTAINER Petr Sloup <petr.sloup@klokantech.com>

ENV NODE_ENV="production"
VOLUME /data
WORKDIR /data
EXPOSE 80
ENTRYPOINT ["/bin/bash", "/usr/src/app/run.sh"]

RUN dnf -y update

RUN echo $'[baseos] \n\
name=CentOS-$releasever - BaseOS \n\
mirrorlist=http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=baseos&infra=$infra \n\
gpgcheck=0 \n\
[appstream] \n\
name=CentOS-$releasever - Appstream \n\
mirrorlist=http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=appstream&infra=$infra \n\
gpgcheck=0 \n\
[powertools] \n\
name=CentOS-$releasever - PowerTools \n\
mirrorlist=http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=powertools&infra=$infra \n\
gpgcheck=0' > /etc/yum.repos.d/centos.repo

RUN dnf -y install \
    curl \
    nodejs \
    unzip \
    python2 \
    pkgconf-pkg-config \
    make \
    gcc-c++ \
    cairo-devel \
    mesa-libGLES-devel \
    mesa-libgbm-devel \
    mesa-dri-drivers \
    protobuf-devel \
    llvm-libs \
    libXxf86vm-devel \
    xorg-x11-server-Xvfb \
    xorg-x11-utils 

RUN ln -s /usr/bin/python2 /usr/bin/python
RUN mkdir -p /usr/src/app
COPY / /usr/src/app
RUN cd /usr/src/app && npm install --production
