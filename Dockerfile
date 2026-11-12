FROM ubuntu:22.04
#-------------------------------------------------------------------------------------
RUN useradd -m vt_admin
RUN mkdir -p /home/vt_admin/.ssh && chown -R vt_admin:vt_admin /home/vt_admin
#-------------------------------------------------------------------------------------
RUN apt-get update && apt-get install -y software-properties-common && \
    add-apt-repository universe && \
    add-apt-repository multiverse && \
    apt-get clean && rm -rf /var/lib/apt/lists/*
#-------------------------------------------------------------------------------------
RUN apt-get update && apt-get install -y wget \
    make \
    sudo \
    gcc \
    nano \
    libssl-dev \
    libbz2-dev \
    libffi-dev \
    zlib1g-dev \
    git \
    nano \
    vim \
    tree \
    lsb-release
#-------------------------------------------------------------------------------------
RUN usermod -aG sudo vt_admin && echo "vt_admin ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
#-------------------------------------------------------------------------------------
WORKDIR /tmp
RUN wget https://www.python.org/ftp/python/3.9.6/Python-3.9.6.tgz && \
    tar xzf Python-3.9.6.tgz && \
    cd Python-3.9.6 && \
    ./configure --enable-optimizations && \
    make altinstall 
#-------------------------------------------------------------------------------------
RUN mkdir -p /home/vt_admin/ansible/ && chown -R vt_admin:vt_admin /home/vt_admin/ansible/
WORKDIR /home/vt_admin/ansible/
WORKDIR /home/vt_admin/ansible/
COPY . .
RUN pip3.9 install -r requirements.txt
RUN chown -R vt_admin:vt_admin /home/vt_admin/ansible/
