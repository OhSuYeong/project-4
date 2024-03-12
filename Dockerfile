FROM centos:7
RUN yum clean all
RUN yum update -y
RUN yum -y install wget git httpd
RUN wget http://rpms.remirepo.net/enterprise/remi-release-7.rpm 
RUN yum -y localinstall remi-release-7.rpm
RUN yum -y install epel-release yum-utils
RUN yum-config-manager --enable remi-php74 #php7.4버전을 설치하겠다
RUN yum -y install php php-fpm php-gd php-mysql php-xml
RUN git clone https://github.com/xpressengine/xe-core.git /var/www/html/xe # /var/www/html/xe 에 xpressengine 클론
WORKDIR /var/www/html/xe
RUN mkdir files
WORKDIR /var/www/html
RUN chmod -R 707 xe
RUN chown -R apache:apache xe #루트가 아닌 apache에 권한 부여
EXPOSE 80
CMD httpd -D FOREGROUND # 컨테이너에서 아파치가 실행되도록 함
