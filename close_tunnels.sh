echo "Closing all ST SSH Tunnels..."
ps -ef | grep root@192.168.24.20 | grep -v grep | awk '{print $2}' | xargs kill -9
echo -e "All tunnels closed!\n"