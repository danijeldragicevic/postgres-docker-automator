# Postgres Docker Automator 
Simple bash scripts to create and run Docker containers for a PostgreSQL database and the Adminer web app for database management.

# Technology
- Docker 27.2.0
- Bash 3.2.57
- PostgreSQL 15.3
- Adminer 4.8.1

# To create and run the containers
Please make sure you have the Docker installed on your machine.
```
$ docker --version
Docker version 27.2.0, build 3ab4256
```
<br>

Navigate to the root directory of the project and execute following to give the necessary permission for the scripts:
```
$ chmod +x scripts/*.sh
```
<br>

To create PostgresSQL and Adminer containers run the following script:
```
$ ./scripts/run_containers.sh
```
<br>

The output should be similar to the following:
```
e8ef12ad5d65425ba5329694086174a04db7d4faaef6beb3836eaf29ab5b1ade
hyper-volume
Docker network and volume created successfully.
Unable to find image 'postgres:15.3' locally
15.3: Pulling from library/postgres
648e0aadf75a: Pull complete 
f715c8c55756: Pull complete 
b11a1dc32c8c: Pull complete 
Digest: sha256:8775adb39f0db45cf4cdb3601380312ee5e9c4f53af0f89b7dc5cd4c9a78e4e8
Status: Downloaded newer image for postgres:15.3
db3eaaf9e903d183dc62307c57d51ad71408de320753cedc4ff3a3c77a618707

Unable to find image 'adminer:4.8.1' locally
4.8.1: Pulling from library/adminer
73226dab8db5: Pull complete 
ed94e1c95a57: Pull complete 
884bce373183: Pull complete 
Digest: sha256:34d37131366c5aa84e1693dbed48593ed6f95fb450b576c1a7a59d3a9c9e8802
Status: Downloaded newer image for adminer:4.8.1
9585599ed62ff843eaedd022f3575c3ad3f0b9464860921ed7fe81e4dd3b25a3

Waiting for PostgreSQL to initialize...
CREATE TABLE
INSERT 0 1
Table created and record inserted successfully.

The Postgres and Adminer containers are up and running:
CONTAINER ID   IMAGE           STATUS          PORTS                    NAMES
9585599ed62f   adminer:4.8.1   Up 5 seconds    0.0.0.0:8080->8080/tcp   hyper-adminer
db3eaaf9e903   postgres:15.3   Up 19 seconds   0.0.0.0:5432->5432/tcp   hyper-postgres
```
<br>

To check the database via the CLI, we can execute the following command:
```
$ PGPASSWORD=hyper2023 psql --host=localhost --port=5432 --username=hyper --dbname=hyper-db --command="SELECT * FROM users;"
 id | user_first_name | user_last_name 
----+-----------------+----------------
  1 | Danijel         | Dragicevic
(1 row)
```
<br>

To access the database via the Adminer web app, open the browser and navigate to the following URL:
```
http://localhost:8080

# Credentials
System: PostgreSQL
Server: hyper-postgres
Username: hyper
Password: hyper2023
Database: hyper-db
```
<br>

To stop and remove the containers, network, and volume from your system run the following script:
```
$ ./scripts/cleanup.sh
```
<br>

The output should look like this:
```
hyper-postgres
Removed container: hyper-postgres
hyper-adminer
Removed container: hyper-adminer
hyper-network
Removed network: hyper-network
hyper-volume
Removed volume: hyper-volume
```

# Licence
[![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
