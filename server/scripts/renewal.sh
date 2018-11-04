#!/bin/bash

service apache2 stop
/certbot-auto renew
service apache2 start
