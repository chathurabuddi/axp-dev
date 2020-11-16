FROM xqdocker/ubuntu-oracle-java:8

# Install MySql
ENV DEBIAN_FRONTEND noninteractive

RUN \
    apt-get update && \
    apt-get install -y vim && \
    apt-get install -y mysql-server mysql-client && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir -p /var/run/mysqld/

VOLUME /var/lib/mysql

COPY my.cnf /etc/mysql/my.cnf
COPY mysql-entrypoint.sh /mysql-entrypoint.sh
COPY mysql-healthcheck.sh /mysql-healthcheck.sh
ENTRYPOINT ["/mysql-entrypoint.sh"]
HEALTHCHECK CMD /mysql-healthcheck.sh
EXPOSE 3306 33060
CMD ["mysqld", "--user=root", "--lower_case_table_names=1"]
