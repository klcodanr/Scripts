#!/bin/bash
ssh -f root@192.168.24.20 -L 8080:localhost:8080 -N
ssh -f root@192.168.24.20 -L 8082:localhost:8082 -N
ssh -f root@192.168.24.20 -L 8084:localhost:8084 -N
echo -e "Created the following SSH Tunnels:"
echo -e "Port --- Host --- Remote Port"
echo -e "8080 --- Dispatcher --- 80"
echo -e "8082 --- Author --- 4502"
echo -e "8084 --- Publish --- 4503\n"