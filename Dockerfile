# creating the docker image 
FROM continuumio/miniconda3
# creation of a ras directory 
RUN mkdir -p /data/ras

 

# creation of a working directory inside the container.
WORKDIR /opt

RUN apt-get update && \
    apt-get upgrade -y && \ 	
    apt-get install -y \
	cron \
    vim &&\
    apt-get clean -y &&\
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
    

# copy flame library, backend and frontend inside the container.
COPY flame /opt/flame
COPY namastox /opt/backend/namastox
COPY namastox_API /opt/backend/namastox_API


# create and active namastox conda environment.
WORKDIR /opt/backend/namastox
COPY environment.yml .
RUN  conda update -n base -c defaults conda
RUN  conda env create -f environment.yml

ENV PATH /opt/conda/envs/namastox/bin:$PATH



#Install and confgure flame
WORKDIR /opt/flame
RUN pip install -e .

# install and configure namastox
WORKDIR /opt/backend/namastox
RUN pip install -e .
RUN namastox -c config -d /data
RUN chmod -R 777 /data/ras/
RUN flame -c config -d /data

WORKDIR /var/log/
RUN mkdir nginx
RUN chown -R www-data:www-data /var/log/nginx;
RUN chmod -R 755 /var/log/nginx;

# complete namastox_API install
WORKDIR /opt/backend/namastox_API
RUN pip install --no-cache-dir -r requirements.txt
RUN pip install gunicorn==21.2.0
RUN useradd --no-create-home nginx

RUN chmod -R 755 /opt/conda/envs/namastox/var/log/nginx/
RUN chmod -R 777 /opt/backend/namastox_API/

COPY ./server-conf/.htpasswd /opt/conda/envs/namastox/etc/nginx/
COPY ./server-conf/nginx.conf /opt/conda/envs/namastox/etc/nginx/
COPY ./server-conf/flask-site-nginx.conf /opt/conda/envs/namastox/etc/nginx/conf.d/
COPY ./server-conf/uwsgi.ini /opt/backend/namastox_API/
COPY ./server-conf/supervisord.conf /opt/conda/envs/namastox/etc/
COPY start.sh /opt/backend/namastox_API

RUN chmod +x /opt/backend/namastox_API/start.sh 

CMD ["/opt/backend/namastox_API/start.sh"]

