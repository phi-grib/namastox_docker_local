#!/bin/bash
/usr/bin/env >> /etc/environment
service cron start
supervisord -n
