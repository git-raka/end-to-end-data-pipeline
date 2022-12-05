# Project Overview
In this project We use kafka cluster Because of its fault tolerance and scalability, is often used in the big size data space as a reliable way to ingest and move large amounts of data streams very quickly

**Architecture Preview**
![rehdrtj](https://user-images.githubusercontent.com/77326619/205449912-3d3bb152-86c3-45bb-890e-5150af4dda58.png)

**Kafka Clusters Requirements**              
| **Item**          | **Requirements**  |
| :-------------: | :-------------: |
| Memory  | 3x 8gb  |
| CPU  | 3x 4 cores  |
|Storage | 3x 50gb  |

### 1.Create directory for kafka and download kafka.tar ###
```
mkdir kafka && cd kafka && wget https://downloads.apache.org/kafka/3.3.1/kafka_2.13-3.3.1.tgz
```

### Create cluster configuration ###
If you open the config/server.properties file, you will see several configuration options (you can ignore most of them for now).
However, there are three properties that have to be unique for each broker instance:

<img width="513" alt="image" src="https://user-images.githubusercontent.com/77326619/205552777-5665ef7c-4d83-4fd6-96b4-9c0990d8869f.png">

Since we will have 3 servers, it’s better to maintain 3 configuration files for each server. Copy the config/server.properties file and make 3 files for each server instance:
```
cp config/server.properties config/server.1.properties
cp config/server.properties config/server.2.properties
cp config/server.properties config/server.3.properties
```
Server1.properties
```
broker.id=1
listeners=PLAINTEXT://:9093
log.dirs=/kafka/logs2
```
Server2.properties
```
broker.id=2
listeners=PLAINTEXT://:9094
log.dirs=/kafka/logs2
```
Server3.properties
```
broker.id=3
listeners=PLAINTEXT://:9095
log.dirs=/kafka/logs3
```
### Create the log directories ###
```
mkdir /tmp/kafka-logs1
mkdir /tmp/kafka-logs2
mkdir /tmp/kafka-logs3
```
### Create zookeeper systemd service in node kafka1 ###
```
sudo nano /etc/systemd/system/zookeeper.service
```
append this :
```
[Unit]
Requires=network.target remote-fs.target
After=network.target remote-fs.target

[Service]
Type=simple
User=root
ExecStart=/root/kafka/bin/zookeeper-server-start.sh /root/kafka/config/zookeeper.properties
ExecStop=/root/kafka/bin/zookeeper-server-stop.sh
Restart=on-abnormal

[Install]
WantedBy=multi-user.target
```
### start zookeeper ###
```
sudo systemctl start zookeeper.service
```

### Create service kafka in each cluster ###
```
sudo nano /etc/systemd/system/kafka.service
```
Append this : 
```
[Unit] 
 Requires=zookeeper.service 
 After=zookeeper.service 
  
 [Service] 
 Type=simple 
 User=root 
 ExecStart=/bin/sh -c '/root/kafka/bin/kafka-server-start.sh /root/kafka/config/server.properties > /root/kafka/logs/kafka.log 2>&1' 
 ExecStop=/root/kafka/bin/kafka-server-stop.sh 
 Restart=on-abnormal 
  
 [Install] 
 WantedBy=multi-user./root 
 ### start kafka in each cluster ###
 ```
 sudo systemctl start kafka
 ```
