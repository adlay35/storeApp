---version
java 23.0.2+7-58 x64
C:\Program Files\Java\jdk-23\bin

apache-tomcat-10.1.40-windows-x64
C:\Program Files\apache-tomcat-10.1.40

Apache Maven 3.8.8

Mysql 8.0.26

---프로젝트 실행법---
1. 로컬 mysql에 store_db라는 이름의 db를 먼저 만들어야함
-> mysql 실행시키고 CREATE DATABESE store_db;

2. cmd 켜고 cmd /c "mysql -u root -p store_db < C:\Users\Ye Chan\Desktop\storeApp\store_db.sql"  실행. 
(경로는 프로젝트 폴더에 있는 store_db.sql파일 경로로 바꾸야함)
-> 실행 안되면 mysql이 환경변수에 등록 안된거임. 등록

3. mysql-connector 연결
-> 컴퓨터 C:\Program Files (x86)\MySQL\Connector J 8.0 경로에 있는 mysql-connector-java-8.0.26.jar 복사
-> 프로젝트 폴더 내  store\src\main\webapp\WEB-INF\lib 이 경로에 원래 있는 jar 파일 삭제하고 붙여넣기

4. 이클립스에서 실행
file -> open project from file system -> 창 뜨면 directory 눌러서 폴더 그대로 추가

storeApp -> store -> src -> main -> webapp -> index.jsp 찾아 들어가서 누르고 run (ctrl + f11)
창 뜨면 tomcat ~~ server at localhost 누르고 finish

---참고---
프로젝트 패키징 -> mvn clean package
사이트 강제 새로고침 -> Ctrl + F5

덤프 파일 내보내기
mysqldump -u root -p store_db > C:\Users\user\Desktop\storeApp\store_db.sql  파일 경로 적으면 됨(store_db.sql의 경로)
데이터 덮어쓰기
cmd /c "mysql -u root -p store_db < C:\Users\Ye Chan\Desktop\storeApp\store_db.sql" 