#!/bin/bash
curl https://raw.githubusercontent.com/klcodanr/Scripts/master/create_dev_tunnel.sh > ~/Desktop/st/create_dev_tunnel
curl https://raw.githubusercontent.com/klcodanr/Scripts/master/create_qa_tunnel.sh > ~/Desktop/st/create_qa_tunnel
curl https://raw.githubusercontent.com/klcodanr/Scripts/master/create_prod_tunnel.sh > ~/Desktop/st/create_prod_tunnel
curl https://raw.githubusercontent.com/klcodanr/Scripts/master/close_tunnels.sh > ~/Desktop/st/close_tunnels
curl https://raw.githubusercontent.com/klcodanr/Scripts/master/update_st_scripts.sh > ~/Desktop/st/update_st_scripts
curl https://raw.githubusercontent.com/klcodanr/Scripts/master/connect_to_st_mac.sh > ~/Desktop/st/connect_to_st_mac
chmod +x ~/scripts/*
echo "Updated all scripts!"