FROM xqdocker/ubuntu-oracle-java:8

# Install MySql
ENV DEBIAN_FRONTEND noninteractive

RUN \
    apt-get update && \
    apt-get install -y mysql-server mysql-client && \
    rm -rf /var/lib/apt/lists/*
    
# Define mountable directories.
VOLUME ["/etc/mysql", "/var/lib/mysql"]

# Define working directory.
WORKDIR /data

# Expose ports.
EXPOSE 3306
