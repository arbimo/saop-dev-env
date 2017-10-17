FROM saop:latest

MAINTAINER Arthur Bit-Monnot <arthur.bitmonnot@gmail.com>

USER root

RUN cd /home/saop/windninja/build && make install

# Move windninja to opt
#RUN cp -r /home/saop/windninja /opt

RUN echo "root:root" | chpasswd

# Install CLion
RUN cd /opt && wget https://download.jetbrains.com/cpp/CLion-2017.2.tar.gz
RUN cd /opt && tar -xf CLion-2017.2.tar.gz


# Install make and compilers
RUN apt-get update && apt-get install -y\
    build-essential autoconf automake openjdk-8-jre
RUN apt-get update && apt-get install -y \
    emacs htop
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/*


CMD ["/opt/clion-2017.2/bin/clion.sh"]

USER saop

ENV PYTHONPATH ${PYTHONPATH}:/home/saop/fire-rs-saop/python

ENV WINDNINJA_CLI_PATH /usr/local/bin
