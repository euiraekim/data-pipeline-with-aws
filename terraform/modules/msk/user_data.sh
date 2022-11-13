#cloud-boothook
#!/bin/bash

# 자바 다운로드
sudo yum install java-1.8.0 -y

# kafka client 다운로드
wget https://archive.apache.org/dist/kafka/2.6.2/kafka_2.12-2.6.2.tgz

# 압축 풀기
tar -xzf kafka_2.12-2.6.2.tgz

# 폴더명 변경
mv kafka_2.12-2.6.2 kafka

# 설정 추가
echo security.protocol=PLAINTEXT > ~/kafka/bin/client.properties

# git 설치
sudo yum install git -y
