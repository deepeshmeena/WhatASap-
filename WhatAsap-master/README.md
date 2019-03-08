#WebContent, build, src and all other folder except whatasap are the backend folders which are used for backend.
#and whatasap is the whole frontend app.

Server and Database:-
1) Open a terminal, and execute

    i)   cd ~
    
    ii)  mkdir postgresql
    
    iii) cd postgresql
    
    This creates a directory where your database and other files will be located.
2)  Now execute

    /usr/lib/postgresql/10/bin/initdb -D dbis
    
   (If you have an older version of PostgreSQL, your path may be slightly different, such as 9.5 or 9.4 instead of 9.6)
   and then edit   dbis/postgresql.conf   and
    
   i)  change
             #port = 5432 (or any port you want)
             
     ii)   Also change 
     
             #unix_socket_directories = '/var/run/postgresql'
         to
             #unix_socket_directories = '/xxx/postgresql'
             
        where xxx is the full path of your home directory 
        (e.g. /home/anshua/postgresql if your login is anshua)
    iii) Now start an instance of postgresql by using either of these methods:
        a) Either run:
        
                /usr/lib/postgresql/10/bin/pg_ctl -D ~/postgresql/dbis -l logfile start
                
            and check the status by looking at the file logfile to make sure it has started
            
            (BEFORE YOU LOG OUT:  run
            
                /usr/lib/postgresql/10/bin/pg_ctl -D ~/postgresql/dbis stop   
                
            )
            
         b) OR  run
         
               /usr/lib/postgresql/10/bin/postmaster -D ~/postgresql/dbis  &
               
            and make sure the messages show that postgresql has started properly;
            
            (BEFORE YOU LOG OUT kill the process to shut down postgresql)
            
3)Once postgres is started, connect to it

    psql -h localhost -p xyz0 -d postgres
    
  where xyz0 is the port number you defined earlier
  
    1)  Use the help menu to figure out basic psql commands, such as \d 
    
        See what tables are there by typing \d
        
        Explore a few commands using \? and \h. 
        
        Type in any SQL command and hit enter to execute the command. 
        You need to end SQL commands with a semi colon.  See below for some sample SQL commands.
        
        Exit the shell using \q
        
     2) Run some basic SQL commands such as the following and see what happens
     
        create table test (i int, name varchar(20));
        
        insert into test values (5, 'Ram');
        
        insert into test values (10, 'Sita');
        
        select * from test;
        
        drop table test;
        


steps to create app.


Backend:-

0) Install tomcat(latest version)
1) open Eclipse
2) create Dynamic web Project
3) right click on the project and select *Build Path -> Configure Build Path -> Java Build Path -> Library*
    add these jar files as Add External Jars
    
     i) el-api.jar
     
    ii) jackson-annotations-2.9.0.jar
    
   iii) jackson-core-2.9.6.jar
   
    iv) jackson-databind-2.9.6.jar
    
     v) jsoup-1.11.3.jar
     
    vi) jsp-api.jar
    
    vii) postgresql-42.2.4.jar
   
    viii) servlet-api.jar
  
  Apply and close
  
4) right click on the project and select *Run Configurations -> Apache Tomcat -> Tomcat v9.0 server at localhost -> classpath
   add postgresql-42.2.4.jar to bootstrap entries
   and add these files to User Entries
   
    i) bootstrap.jar     /opt/tomcat9/bin/
   
    ii) tomcat-juli.jar   /opt/tomcat9/bin/
  
    iii) tools.jar         /usr/lib/jvm/java-8-oracle/lib/
 
    iv) jackson-annotations-2.9.0.jar
  
    v) jackson-core-2.9.6.jar
   
    vi) jackson-databind-2.9.6.jar
  
    vii) jsoup-1.11.3.jar
 
    viii) postgresql-42.2.4.jar

  apply and run
  

5) copy all files of src folder to your src folder.

Frontend:-
1) open terminal and type *flutter create whatasap*
2) copy all files from lib folder to your lib folder
3) now run in terminal *flutter run*
