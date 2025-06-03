java 23.0.2+7-58 x64
C:\Program Files\Java\jdk-23\bin

apache-tomcat-10.1.40-windows-x64
C:\Program Files\apache-tomcat-10.1.40

Apache Maven 3.8.8

Mysql 8.0.26

프로젝트 패키징 -> mvn clean package
사이트 강제 새로고침 -> Ctrl + F5

내보내기
mysqldump -u root -p store_db > C:\Users\user\Desktop\store_db.sql
덮어쓰기
mysqldump -u root -p store_db < C:\Users\user\Desktop\store_db.sql