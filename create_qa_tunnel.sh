#!/bin/bash
ssh -f root@192.168.24.20 -L 8085:localhost:8085 -N
ssh -f root@192.168.24.20 -L 8086:localhost:8086 -N
ssh -f root@192.168.24.20 -L 8087:localhost:8087 -N
ssh -f root@192.168.24.20 -L 8088:localhost:8088 -N
ssh -f root@192.168.24.20 -L 8089:localhost:8089 -N
ssh -f root@192.168.24.20 -L 8090:localhost:8090 -N
ssh -f root@192.168.24.20 -L 8091:localhost:8091 -N
ssh -f root@192.168.24.20 -L 8092:localhost:8092 -N
ssh -f root@192.168.24.20 -L 8093:localhost:8093 -N
ssh -f root@192.168.24.20 -L 8094:localhost:8094 -N
ssh -f root@192.168.24.20 -L 8095:localhost:8095 -N
ssh -f root@192.168.24.20 -L 8096:localhost:8096 -N
ssh -f root@192.168.24.20 -L 8106:localhost:8106 -N
ssh -f root@192.168.24.20 -L 8107:localhost:8107 -N
echo -e "Created the following SSH Tunnels:\nPort --- Host --- Remote Port\n"
echo -e "8085 --- Author 1 --- 22"
echo -e "8086 --- Author 1 --- 4502"
echo -e "8087 --- Author 2 --- 22"
echo -e "8088 --- Author 2 --- 4502"
echo -e "8089 --- Publish 1 --- 4503"
echo -e "8090 --- Publish 1 --- 22"
echo -e "8091 --- Publish 2 --- 4503"
echo -e "8092 --- Publish 2 --- 22"
echo -e "8093 --- Dispatcher --- 80"
echo -e "8094 --- Dispatcher --- 22"
echo -e "8095 --- Dispatcher --- 80"
echo -e "8106 --- Mongo --- 22"
echo -e "8107 --- Mongo --- 27017"