FROM xqdocker/ubuntu-oracle-java:8

#######################
#### INSATLL MYSQL ####
#######################

RUN groupadd -r mysql && useradd -r -g mysql mysql

ENV GOSU_VERSION 1.12
RUN set -eux; \
	savedAptMark="$(apt-mark showmanual)"; \
	apt-get update; \
	apt-get install -y --no-install-recommends gnupg gnupg-curl dirmngr ca-certificates wget; \
	rm -rf /var/lib/apt/lists/*; \
	dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')"; \
	wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch"; \
	wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch.asc"; \
	export GNUPGHOME="$(mktemp -d)"; \
	gpg --batch --keyserver hkps://keys.openpgp.org --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4; \
	gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu; \
	rm -rf "$GNUPGHOME" /usr/local/bin/gosu.asc; \
	apt-mark auto '.*' > /dev/null; \
	[ -z "$savedAptMark" ] || apt-mark manual $savedAptMark > /dev/null; \
	apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false; \
	chmod +x /usr/local/bin/gosu; \
	gosu --version; \
	gosu nobody true

RUN mkdir /docker-entrypoint-initdb.d

RUN apt-get update && apt-get install -y --no-install-recommends pwgen openssl perl xz-utils && rm -rf /var/lib/apt/lists/*

RUN set -ex; \
	key='A4A9406876FCBD3C456770C88C718D3B5072E1F5'; \
	export GNUPGHOME="$(mktemp -d)"; \
	gpg --batch --keyserver ha.pool.sks-keyservers.net --recv-keys "$key"; \
	gpg --batch --export "$key" > /etc/apt/trusted.gpg.d/mysql.gpg; \
	rm -rf "$GNUPGHOME"; \
	apt-key list > /dev/null

ENV MYSQL_MAJOR 5.7
ENV MYSQL_VERSION 5.7.32-1ubuntu16.04

RUN echo "deb http://repo.mysql.com/apt/ubuntu/ xenial mysql-${MYSQL_MAJOR}" > /etc/apt/sources.list.d/mysql.list

RUN { \
		echo mysql-community-server mysql-community-server/data-dir select ''; \
		echo mysql-community-server mysql-community-server/root-pass password ''; \
		echo mysql-community-server mysql-community-server/re-root-pass password ''; \
		echo mysql-community-server mysql-community-server/remove-test-db select false; \
	} | debconf-set-selections \
	&& apt-get update && apt-get install -y mysql-server="${MYSQL_VERSION}" && rm -rf /var/lib/apt/lists/* \
	&& rm -rf /var/lib/mysql && mkdir -p /var/lib/mysql /var/run/mysqld /usr/share/zoneinfo \
	&& chown -R mysql:mysql /var/lib/mysql /var/run/mysqld \
	&& chmod 1777 /var/run/mysqld /var/lib/mysql \
	&& find /etc/mysql/ -name '*.cnf' -print0 \
		| xargs -0 grep -lZE '^(bind-address|log)' \
		| xargs -rt -0 sed -Ei 's/^(bind-address|log)/#&/' \
	&& echo '[mysqld]\nskip-host-cache\nskip-name-resolve' > /etc/mysql/conf.d/docker.cnf

VOLUME /var/lib/mysql

COPY my.cnf /etc/mysql/my.cnf
COPY mysql-entrypoint.sh /usr/local/bin/
RUN ln -s usr/local/bin/mysql-entrypoint.sh /entrypoint.sh # backwards compat

#########################
#### INSATLL MAVEN 3 ####
#########################

RUN wget --no-verbose -O /tmp/apache-maven-3.6.3.tar.gz https://downloads.apache.org/maven/maven-3/3.6.3/binaries/apache-maven-3.6.3-bin.tar.gz
RUN tar xzf /tmp/apache-maven-3.6.3.tar.gz -C /opt/
RUN ln -s /opt/apache-maven-3.6.3 /opt/maven
RUN ln -s /opt/maven/bin/mvn /usr/local/bin
RUN rm -f /tmp/apache-maven-3.6.3.tar.gz
ENV MAVEN_HOME /opt/maven

###########################
#### INSATLL DEV TOOLS ####
###########################

RUN apt-get update && apt-get install -y vim curl git zip unzip && rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["mysql-entrypoint.sh"]
EXPOSE 3306 33060 8243 8280 9443 9444 9445 5005
CMD ["mysqld", "--lower_case_table_names=1"]
