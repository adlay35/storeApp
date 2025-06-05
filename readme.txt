---version
java 23.0.2+7-58 x64
C:\Program Files\Java\jdk-23\bin

apache-tomcat-10.1.40-windows-x64
C:\Program Files\apache-tomcat-10.1.40

Apache Maven 3.8.8

Mysql 8.0.26

---참고
프로젝트 패키징 -> mvn clean package
사이트 강제 새로고침 -> Ctrl + F5

---db 동기화
로컬 mysql에 store_db라는 이름의 db를 먼저 만들어야함 -> CREATE DATABESE store_db;

아래 명령어는 cmd 혹은 파워쉘에서 실행
덤프 파일 내보내기
mysqldump -u root -p store_db > C:\Users\user\Desktop\storeApp\store_db.sql  파일 경로 적으면 됨(store_db.sql의 경로)
데이터 덮어쓰기
cmd /c "mysql -u root -p store_db < C:\Users\Ye Chan\Desktop\storeApp\store_db.sql" 

---db 사용하기 전에 mysql-connector 연결하기.
C:\Program Files (x86)\MySQL\Connector J 8.0 여기 경로에 있는 mysql-connector-java-8.0.26.jar 복사해서
store\src\main\webapp\WEB-INF\lib 이 경로에 붙여 넣기