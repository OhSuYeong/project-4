# project-4
## 구현 요소

- OS는 ubuntu 사용
- xpressengine 게시판 배포를 위한 이미지를 생성
- mysql 5.7 과 연계
- 게시판 페이지 실행 확인

---

## 구현진행

xpressengine

- 페이지 : https://www.xpressengine.com/
- github : https://github.com/xpressengine/xe-core.git

우선 작업을 진행할 폴더 생성 후 Dockerfile 생성

```bash
mkdir xpress_maker; cd xpress_maker
vi Dockerfile
```

[Dockerfile]

```bash
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
```

image 생성 및 Container 생성

```bash
docker build -t xe:1.0 .
docker container run -d --name db1 -e MYSQL_ROOT_PASSWORD=test123 -e MYSQL_DATABASE=xe mysql:5.7
docker container run -d --name xe1 --link db1:mysql -p 8080:80 xe:1.0
```

이후 docker container ls로 확인하고 [http://211.183.3.100:8080/xe](http://211.183.3.100:8080/xe에) 에 접속하여 계정 생성

만약 [http://211.183.3.100:8080](http://211.183.3.100:8080/xe에) 가 제대로 동작하지 않는다면

```bash
sudo systemctl restart docker
docker container ls --all # 아이디 확인 후 container 재실행
docker container start <id>
```

이후 다시 [http://211.183.3.100:8080/xe](http://211.183.3.100:8080/xe에) 에 접속
![Untitled](https://github.com/OhSuYeong/project-4/assets/101083171/b0caae04-abac-4b1e-b248-2f5e26a02be1)
제대로 홈페이지 동작을 확인한다면 dockerhub에 push

```bash
docker tag xe:1.0 ohsuyeong/rapaeng4:xe
docker push ohsuyeong/rapaeng4:xe
```
![Untitled2](https://github.com/OhSuYeong/project-4/assets/101083171/c96584d5-15ec-40d2-9178-47e71e2552a4)
