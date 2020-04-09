Solution
Because I’m not an Oracle expert, I started looking for help on the internet. I came across a comment where someone wrote that after running the container two SQL commands should be executed and everything will work as it should. These are the commands:

ALTER SYSTEM SET FILESYSTEMIO_OPTIONS=DIRECTIO SCOPE=SPFILE;
ALTER SYSTEM SET DISK_ASYNCH_IO=FALSE SCOPE=SPFILE;
Docker-Compose
Below I present a ready YAML script, where the above configuration can be kept in the init.sql file in the “config” folder that will be executed during container launch.

pawel@pawel:~/Desktop/Blog/oracle-db$ find .
./config
./config/init.sql
./docker-compose.yml
Contents of the docker-compose.yml file:

version: '2.1'
services:
  oracle-db:
    hostname: oracle-db
    container_name: oracle-db
    image: wnameless/oracle-xe-11g-r2
    volumes:
      - ./config:/docker-entrypoint-initdb.d
    ports:
      - "1521:1521"
      - "15080:8080"
	  
	  
Here you go:

version: '2'
services:
  database:
    image: <internal-registry>/oracle/database:<tag> # e.g: registry.company.br/oracle/database:12.1.0.2-ee
    environment:
      - ORACLE_SID=xe
      - ORACLE_PDB=test
    volumes:
      - ./oracle/oradata:/opt/oracle/oradata # persistent oracle database data.
      - ./data-bridge:/data-bridge # just to have someplace to put data into the running container if needed
    ports:
      - 1521:1521
      - 8080:8080
      - 5500:5500

Problem
You just have one problem with this approach:

Actually the ./oracle/oradata folder is owned by a host user in the host machine, usually the root user or yours. 
The oracle docker image runs everything under the oracle user, created in the Dockerfile. 
When it starts, it runs the runOracle.sh under the oracle user. 
But when it mounts the volume into the container, it mounts the folder under root permissions, 
so the database instance that is running under the oracle permissions is unable to write into the volume.


Start the container:
$ docker-compose up -d
$ docker-compose exec database bash
$ id oracle
uid=1000(oracle) gid=500(dba) groups=500(dba),501(oinstall)
Back to the container host, you run:
$ sudo chown -R 1000:1000 ./oracle
Restart the container
$ docker-compose stop
$ docker-compose start


RUN chown -R oracle:dba /opt/oracle/oradata
VOLUME /opt/oracle/oradata	  



docker system prune