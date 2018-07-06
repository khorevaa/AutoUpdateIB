FROM debian:latest
LABEL maintainer="khorevaa@gmail.com"

ADD  setup.sh /opt/  
RUN  /bin/bash /opt/setup.sh

ADD build.sh /opt


RUN mkdir -p /opt/builder/
ADD AutoUpdateIB  /opt/builder/
ADD AutoUpdateIB-completion /opt/builder/
ADD AutoUpdateIB.exe /opt/builder/

RUN chmod +x /opt/build.sh

VOLUME /opt/debian
VOLUME /opt/dist

WORKDIR /opt

ENTRYPOINT [ "./build.sh" ]
