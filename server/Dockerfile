FROM python:2.7-jessie
MAINTAINER SPARCS OTL TEAM <otl@sparcs.org>

# Packages installation
RUN apt-get update
RUN apt-get install -y \
    openssh-server \
    sudo \
    vim \
    tmux \
    locales \
    wget \
    cron \
    git \
    mysql-client \
    libmysqlclient-dev \
    unixodbc \
    unixodbc-dev \
    apache2 \
    libapache2-mod-wsgi

# Creating users
RUN adduser --gecos "" --disabled-password sysop
RUN usermod -G sudo sysop
RUN adduser --gecos "" --disabled-password wheel
RUN usermod -G sudo wheel

# Creating public key
RUN ssh-keygen -t rsa -f /root/.ssh/id_rsa -N ""

# Locale configuration
RUN sed -i -e 's/# ko_KR.UTF-8 UTF-8/ko_KR.UTF-8 UTF-8/' /etc/locale.gen
RUN dpkg-reconfigure --frontend=noninteractive locales
RUN update-locale LANG=ko_KR.UTF-8
RUN echo "export LANG=ko_KR.UTF-8" >> /etc/environment
RUN echo "export LANGUAGE=ko_KR.UTF-8" >> /etc/environment
RUN echo "export LC_ALL=ko_KR.UTF-8" >> /etc/environment

# Certbot installation
RUN wget https://dl.eff.org/certbot-auto
RUN chmod u+x certbot-auto

# Apache configuration
COPY ./otl.conf /etc/apache2/sites-available/otl.conf
COPY ./otl-test.conf /etc/apache2/sites-available/otl-test.conf
RUN a2enmod ssl

# Repository cloning and pip installation
RUN git clone https://github.com/sparcs-kaist/otlplus.git /var/www/otlplus
WORKDIR /var/www/otlplus
RUN pip install -r requirements.txt

# Copying private files
COPY ./settings_local.py /var/www/otlplus/otlplus/settings_local.py
COPY ./keys /var/www/otlplus/keys
COPY ./scripts/do_import_user_major.py /var/www/otlplus/do_import_user_major.py
COPY ./scripts/import_scholardb_all.sh /var/www/otlplus/import_scholardb_all.sh
COPY ./scripts/update_scholardb.py /var/www/otlplus/update_scholardb.py
COPY ./scripts/update_taken_lecture.py /var/www/otlplus/update_taken_lecture.py
COPY ./scripts/update_taken_lecture_user.py /var/www/otlplus/update_taken_lecture_user.py

# Crontab installation
COPY ./scripts/db_update_script.sh /db_update_script.sh
COPY ./scripts/renewal.sh /renewal.sh
COPY ./scripts/db.sh /backup/db.sh
RUN chmod u+x /db_update_script.sh /renewal.sh /backup/db.sh
RUN echo "# m h dom mon dow command" > mycron
RUN echo "  0 4 *   *   *   . /db_update_script.sh" >> mycron
RUN echo "  0 4 *   *   1   . /renewal.sh" >> mycron
RUN echo "  5 4 *   *   0   . /backup/db.sh" >> mycron
RUN crontab mycron
RUN rm mycron

CMD /bin/bash -c "service ssh start && service cron start && /bin/bash"
