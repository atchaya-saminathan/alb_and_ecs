FROM centos:centos7
MAINTAINER Atchaya
RUN yum -y update && \
  yum -y install httpd json python && \
  yum clean all
COPY index.html /var/www/html/index.html
COPY entry_point.py entry_point.py
COPY entry_point.sh entry_point.sh
RUN chmod -R 777 /etc/httpd && chown -R apache:apache /etc/httpd
RUN python entry_point.py >>  /var/www/html/index.html
EXPOSE 80
CMD ["/usr/sbin/httpd", "-DFOREGROUND"]
