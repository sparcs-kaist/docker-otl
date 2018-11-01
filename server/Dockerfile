FROM python:2.7-jessie
MAINTAINER SPARCS OTL TEAM <otl@sparcs.org>

RUN apt-get update
RUN apt-get install -y \
    locales \
	git \
	mysql-client \
	libmysqlclient-dev \
    unixodbc \
    unixodbc-dev \
    apache2 \
    libapache2-mod-wsgi
RUN a2enmod wsgi

RUN sed -i -e 's/# ko_KR.UTF-8 UTF-8/ko_KR.UTF-8 UTF-8/' /etc/locale.gen
RUN dpkg-reconfigure --frontend=noninteractive locales
RUN update-locale LANG=ko_KR.UTF-8
ENV LANG ko_KR.UTF-8
ENV LANGUAGE ko_KR.UTF-8
ENV LC_ALL ko_KR.UTF-8

RUN virtualenv env
RUN git clone https://github.com/sparcs-kaist/otlplus.git
RUN source env/bin/activate
WORKDIR /otlplus
RUN pip install -r requirements.txt

RUN rm /etc/apache2/sites-available/*
RUN rm /etc/apache2/sites-enabled/*
COPY ./default-ssl.conf /etc/apache2/sites-available/default-ssl.conf
COPY ./otl.conf /etc/apache2/sites-available/otl.conf
RUN ln -s /etc/apache2/sites-available/default-ssl.conf /etc/apache2/sites-enabled/default-ssl.conf
RUN ln -s /etc/apache2/sites-available/otl.conf /etc/apache2/sites-enabled/otl.conf

CMD apachectl -D FOREGROUND
