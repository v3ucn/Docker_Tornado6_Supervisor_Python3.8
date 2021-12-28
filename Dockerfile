#FROM registry.cn-hangzhou.aliyuncs.com/hzmodi/python3.8:v2
FROM yankovg/python3.8.2-ubuntu18.04

RUN sed -i "s@/archive.ubuntu.com/@/mirrors.163.com/@g" /etc/apt/sources.list \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get update --fix-missing -o Acquire::http::No-Cache=True
RUN apt install -y nginx supervisor pngquant

# application
RUN mkdir /root/mytornado
WORKDIR /root/mytornado
COPY  main.py /root/mytornado/
COPY  requirements.txt /root/mytornado/
RUN pip install -r requirements.txt -i https://mirrors.aliyun.com/pypi/simple/

# nginx
RUN rm /etc/nginx/sites-enabled/default
COPY tornado.conf /etc/nginx/sites-available/
RUN ln -s /etc/nginx/sites-available/tornado.conf /etc/nginx/sites-enabled/tornado.conf
RUN echo "daemon off;" >> /etc/nginx/nginx.conf

# supervisord
RUN mkdir -p /var/log/supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# run
CMD ["/usr/bin/supervisord"]