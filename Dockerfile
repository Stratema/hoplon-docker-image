FROM ubuntu:trusty
MAINTAINER Matt Taylor <matt.taylor@stratema.co.uk>

ENV DEBIAN_FRONTEND noninteractive

# Oracle Java 8
RUN apt-get update \
    && apt-get install -y curl wget openssl ca-certificates \
    && cd /tmp \
    && wget -qO jdk8.tar.gz \
       --header "Cookie: oraclelicense=accept-securebackup-cookie" \
       http://download.oracle.com/otn-pub/java/jdk/8u25-b17/jdk-8u25-linux-x64.tar.gz \
    && tar xzf jdk8.tar.gz -C /opt \
    && mv /opt/jdk* /opt/java \
    && rm /tmp/jdk8.tar.gz \
    && update-alternatives --install /usr/bin/java java /opt/java/bin/java 100 \
    && update-alternatives --install /usr/bin/javac javac /opt/java/bin/javac 100
ENV JAVA_HOME /opt/java

# PhantomJS
RUN apt-get install -y phantomjs

# Boot
RUN wget -O /usr/bin/boot https://github.com/boot-clj/boot-bin/releases/download/latest/boot.sh \
    && chmod +x /usr/bin/boot
ENV BOOT_HOME /.boot
ENV BOOT_AS_ROOT yes
ENV BOOT_LOCAL_REPO /m2
ENV BOOT_JVM_OPTIONS=-Xmx2g

# download & install deps, cache REPL, web and Hoplon deps
RUN /usr/bin/boot web \
    -s doesnt/exist \
    -d "hoplon/hoplon:6.0.0-alpha16" \
    -d "adzerk/boot-cljs:1.7.228-1"
    repl -e '(System/exit 0)' && rm -rf target

ENTRYPOINT ["/usr/bin/boot"]
