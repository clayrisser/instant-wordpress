############################################################
# Dockerfile to run BlogDown
# Based on Ubuntu
############################################################

FROM wordpress:latest

MAINTAINER Jam Risser (jamrizzi)

EXPOSE 80

ENV WORDPRESS_TITLE="Instant WordPress"
ENV WORDPRESS_ADMIN_USER=admin
ENV WORDPRESS_ADMIN_EMAIL=admin@example.com
ENV WORDPRESS_ADMIN_PASSWORD=hellowordpress
ENV WORDPRESS_URL=localhost:8888

RUN apt-get update && apt-get install -y python python-pip
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    php wp-cli.phar --allow-root --info && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

COPY ./requirements.txt /app/requirements.txt
RUN pip install -r /app/requirements.txt
COPY ./entrypoint.py /app/entrypoint.py

ENTRYPOINT ["python", "/app/entrypoint.py"]
