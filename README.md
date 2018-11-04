# docker-otl
* This docker-compose will automatically start the `otl` service for domain `otl-test.sparcs.org`.
* Make sure that the DNS record of `otl-test.sparcs.org` to be equal to the IP address of your host before starting the following jobs.
* You should change the password of users `sysop` and `wheel` by executing `passwd sysop` and `passwd wheel` respectively.
* After finishing the jobs, you should contact the KAIST IC team and change the DNS record of `otl.kaist.ac.kr`.
* Also, you should change the DNS records of `otl.sparcs.org` and `otlplus.sparcs.org`.
* Issue certificates for `otl.kaist.ac.kr`, `otl.sparcs.org`, and `otlplus.sparcs.org` and
* change the apache config file to use `otl.conf` instead of `otl-test.conf` by executing the following commands:
```shell
service apache2 stop
/certbot-auto certonly -n --apache -m wheel@sparcs.org --agree-tos -d otl.kaist.ac.kr -d otl.sparcs.org -d otlplus.sparcs.org
rm /etc/apache2/sites-enabled/otl-test.conf
ln -s /etc/apache2/sites-available/otl.conf /etc/apache2/sites-enabled/otl.conf
service apache2 start
```
## Setup
```shell
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update
sudo apt-get install -y docker-ce
sudo curl -L "https://github.com/docker/compose/releases/download/1.23.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo curl -L https://raw.githubusercontent.com/docker/compose/1.23.1/contrib/completion/bash/docker-compose -o /etc/bash_completion.d/docker-compose
git clone https://github.com/sparcs-kaist/docker-otl.git
cd docker-otl
mkdir logs db server/keys server/scripts
```
* The following files should exist the `./server` directory:
  * `otl.conf`
  * `otl-test.conf`
  * `settings_local.py`
* The following files should exist the `./server/keys` directory:
  * `django_secret`
  * `google_client_secrets.json`
  * `sso_secret`
* The following files should exist the `./server/scripts` directory:
  * `do_import_user_major.py`
  * `import_scholardb_all.sh`
  * `update_scholardb.py`
  * `update_taken_lecture.py`
  * `update_taken_lecture_user.py`
  * `db_update_script.sh`
  * `renewal.sh`
  * `db.sh`
```shell
sudo docker-compose up -d
```
