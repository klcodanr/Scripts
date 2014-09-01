#!/bin/bash
ssh -f root@192.168.24.20 -L 8097:localhost:8097 -N
ssh -f root@192.168.24.20 -L 8098:localhost:8098 -N
ssh -f root@192.168.24.20 -L 8099:localhost:8099 -N
ssh -f root@192.168.24.20 -L 8100:localhost:8100 -N
ssh -f root@192.168.24.20 -L 8101:localhost:8101 -N
ssh -f root@192.168.24.20 -L 8102:localhost:8102 -N
ssh -f root@192.168.24.20 -L 8103:localhost:8103 -N
ssh -f root@192.168.24.20 -L 8104:localhost:8104 -N
ssh -f root@192.168.24.20 -L 8108:localhost:8108 -N
ssh -f root@192.168.24.20 -L 8109:localhost:8109 -N
echo -e "Created the following SSH Tunnels:\nPort --- Host --- Remote Port\n"
echo -e "8097 --- Author 1 --- 22"
echo -e "8098 --- Author 1 --- 4502"
echo -e "8099 --- Author 2 --- 22"
echo -e "8100 --- Author 2 --- 4502"
echo -e "8102 --- Publish 1 --- 4503"
echo -e "8101 --- Publish 1 --- 22"
echo -e "8104 --- Publish 2 --- 4503"
echo -e "8103 --- Publish 2 --- 22"
echo -e "8108 --- Mongo --- 22"
echo -e "8109 --- Mongo --- 27017"