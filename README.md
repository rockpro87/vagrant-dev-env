# Vagrant로 개발환경 구성
Vagrant를 활용하여 다양한 개발환경을 간편하게 구축

## 설치 프로그램
- [Oracle Virtualbox](https://www.virtualbox.org/wiki/Downloads)
- [Vagrant](https://www.vagrantup.com/downloads.html)

*현재 Vitualbox 5.1.16, Vagrant 1.9.2 기준*

## Vagrant 사전 작업
``` shell
vagrant box add ubuntu/trusty64
```

Windows에서 nfs 공유를 사용하기 위한 플러그인 설치
``` shell
vagrant plugin install vagrant-winnfsd
```

## PHP 개발환경 구성

프로젝트 폴더를 생성 후 원하는 버전 폴더 내 파일을 복사

``` shell
vagrant up
```
*초기 실행시 VagrantFile에 정의된 Provision 스크립트 실행됨*

## 개발환경 구성 확인

http://web.192.168.33.10.xip.io/ 접속 후 phpinfo가 출력되는 것을 확인

*ubuntu-vhost.sh 파일에 정의된 주소*

> 그 외 설정 값들 변경으로 다양하게 테스트 환경 구축 가능
