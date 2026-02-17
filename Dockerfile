FROM centos:7

# Add the old repos as centos7 is deprecated
RUN sed -i \
    -e 's|^mirrorlist=|#mirrorlist=|g' \
    -e 's|^#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' \
    /etc/yum.repos.d/CentOS-Base.repo

RUN yum -y install epel-release

RUN yum -y update 

RUN yum -y install \
    cmake \
    git \
    vim \
    wget \
    cmake3 \
    octave \
    libxml2 \
    libxml2-devel \
    bc

RUN yum -y install \
    ncurses-devel \
    readline-devel

RUN yum -y install \
    python-dateutil \
    python-six \
    perl-ExtUtils-ParseXS

RUN yum -y install \
    http://www.mdsplus.org/dist/el7/stable/RPMS/noarch/mdsplus-repo-7.50-0.el7.noarch.rpm

RUN yum -y install \
    mdsplus-kernel* \
    mdsplus-java* \
    mdsplus-python* \
    mdsplus-devel*

RUN yum -y groupinstall "Development Tools" 

RUN yum clean all

# Clone MARTe2
RUN git clone https://github.com/aneto0/MARTe2.git /opt/MARTe2

# Clone MARTe2 Components
RUN git clone https://vcis-gitlab.f4e.europa.eu/aneto/MARTe2-components.git /opt/MARTe2-components

# Download EPICS
RUN mkdir /opt/EPICS &&\
   cd /opt/EPICS &&\
   wget https://epics-controls.org/download/base/base-7.0.10.tar.gz &&\
   tar -xvf base-7.0.10.tar.gz &&\
   mv base-7.0.10 epics-base &&\
   rm base-7.0.10.tar.gz &&\
   cd epics-base &&\
   make

# Download open62541 library
#RUN git clone https://github.com/open62541/open62541.git /opt/open62541
# Building open62541 library
#RUN mkdir /opt/open62541/build && \
#    cd /opt/open62541/build && \
#    cmake .. && \
#    make



# Build Marte2
WORKDIR /opt/MARTe2
RUN make -f Makefile.linux

# Environment
ENV MARTe2_DIR=/opt/MARTe2
ENV MARTe2_Components_DIR=/opt/MARTe2-components
ENV LD_LIBRARY_PATH=$MARTe2_DIR/Build/x86-linux/Core/

WORKDIR /workspace
