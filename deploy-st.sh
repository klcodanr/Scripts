function installpackage
{
	echo "Uploading into $server..."
	curl -u admin:admin -F name=com.st.olm.cq.st-com.content-$version.zip -F file=@com.st.olm.cq.st-com.content-$version.zip http://localhost:$port/crx/packmgr/service.jsp
	echo "Installing on $server..."
	curl -u admin:admin -F group=com.st.olm.cq -F name=com.st.olm.cq.st-com.content -F version=$version http://localhost:$port/crx/packmgr/service.jsp?cmd=inst
	echo "Installation to $server complete!"
}

version=$1
if [ "$version" = "" ]; then
	echo "No deploy version specified!"
	exit 1
fi


~/scripts/close_tunnels.sh
~/scripts/create_dev_tunnel.sh
~/scripts/create_qa_tunnel.sh
cd /tmp

echo "Copying release $version..."
cp ~/Box\ Sync/_\ Project\ Delivery/2014_ST\ Micro/releases/com/st/olm/cq/com.st.olm.cq.st-com.content/$version/com.st.olm.cq.st-com.content-$version.zip .

port='8082'
server='DEV Author'
installpackage

port='8084'
server='DEV Publish'
installpackage

echo -e "Installation to DEV complete!\n"

port='8086'
server='QA Author 1'
installpackage

port='8088'
server='QA Author 2'
installpackage

port='8089'
server='QA Publish 1'
installpackage

port='8091'
server='QA Publish 2'
installpackage

echo -e "Installation to QA complete!\n"


