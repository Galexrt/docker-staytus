FROM ubuntu:16.04
LABEL maintainer="Alexander Trost <galexrt@googlemail.com>"

ARG STAYTUS_VERSION="master"
ENV DEBIAN_FRONTEND="noninteractive" TZ="Etc/UTC" TINI_VERSION="v0.19.0"

ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini

RUN chmod +x /tini && \
    apt-get -q update && \
    apt-get -q install -y tzdata ruby ruby-dev nodejs git build-essential \
        libmysqlclient-dev mysql-client  && \
    ln -fs "/usr/share/zoneinfo/${TZ}" /etc/localtime && \
    gem update --system && \
    gem install bundler:1.17.2 procodile && \
    mkdir -p /opt/staytus && \
    useradd -r -d /opt/staytus -m -s /bin/bash staytus && \
    chown staytus:staytus /opt/staytus && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

USER staytus

RUN git clone https://github.com/adamcooke/staytus.git /opt/staytus/staytus && \
    cd /opt/staytus/staytus && \
    git checkout "${STAYTUS_VERSION}" && \
    bundle install --deployment --without development:test && \
    sed -i '4,16 s/^[ ]*#//' /opt/staytus/staytus/db/migrate/20170608083959_create_authie_sessions.authie.rb

USER root

COPY entrypoint.sh /usr/local/bin/entrypoint.sh

RUN chmod +x /usr/local/bin/entrypoint.sh

USER staytus

EXPOSE 8787

ENTRYPOINT ["/tini", "--", "/usr/local/bin/entrypoint.sh"]
