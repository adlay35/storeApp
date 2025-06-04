java 23.0.2+7-58 x64
C:\Program Files\Java\jdk-23\bin

apache-tomcat-10.1.40-windows-x64
C:\Program Files\apache-tomcat-10.1.40

Apache Maven 3.8.8

Mysql 8.0.26

프로젝트 패키징 -> mvn clean package
사이트 강제 새로고침 -> Ctrl + F5

내보내기
mysqldump -u root -p store_db > C:\Users\user\Desktop\storeApp\store_db.sql  파일 경로 적으면 됨
덮어쓰기
mysql -u root -p store_db < C:\Users\user\Desktop\storeApp\store_db.sql
-> 둘 다 리눅스 > 연산자랑 같은 기능임

store\src\main\webapp\WEB-INF\lib
이 안에 mysql-connector-java-8.0.26.jar 집어넣어야함
-> Program(x86)\mysql\connector-server? 대충 이런거 안에 있음