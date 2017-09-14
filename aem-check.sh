#!/bin/bash

# Set Variables
HOST=$1
PAGE=$2

GET_REQUESTS=(
	"$HOST/admin"
	"$HOST/system/console"
	"$HOST/dav/crx.default"
	"$HOST/crx"
	"$HOST/crx/de"
	"$HOST/crx/explorer"
	"$HOST/bin/crxde/logs"
	"$HOST/jcr:system/jcr:versionStorage.json"
	"$HOST/_jcr_system/_jcr_versionStorage.json"
	"$HOST/libs/wcm/core/content/siteadmin.html"
	"$HOST/libs/collab/core/content/admin.html"
	"$HOST/libs/cq/ui/content/dumplibs.html"
	"$HOST/var/linkchecker.html"
	"$HOST/etc/linkchecker.html"
	"$HOST/home/users/a/admin/profile.json"
	"$HOST/home/users/a/admin/profile.xml"
	"$HOST/libs/cq/core/content/login.json"
	"$HOST/content/../libs/foundation/components/text/text.jsp"
	"$HOST/content/.{.}/libs/foundation/components/text/text.jsp"
	"$HOST/apps/sling/config/org.apache.felix.webconsole.internal.servlet.OsgiManager.config/jcr%3acontent/jcr%3adata"
	"$HOST/libs/foundation/components/primary/cq/workflow/components/participants/json.GET.servlet"
	"$HOST/content.pages.json"
	"$HOST/content.languages.json"
	"$HOST/content.blueprint.json"
	"$HOST/content.-1.json"
	"$HOST/content.10.json"
	"$HOST/content.infinity.json"
	"$HOST/content.tidy.json"
	"$HOST/content.tidy.-1.blubber.json"
	"$HOST/content/dam.tidy.-100.json"
	"$HOST/content/content/geometrixx.sitemap.txt "
	"$HOST/content/add_valid_page.query.json?statement=//*"
	"$HOST/content/add_valid_page.qu%65ry.js%6Fn?statement=//*"
	"$HOST/content/add_valid_page.query.json?statement=//*[@transportPassword]/(@transportPassword%20|%20@transportUri%20|%20@transportUser)"
	"$HOST${PAGE}/_jcr_content.json"
	"$HOST${PAGE}/jcr:content.json"
	"$HOST${PAGE}/_jcr_content.feed"
	"$HOST${PAGE}/jcr:content.feed"
	"$HOST${PAGE}/pagename._jcr_content.feed"
	"$HOST${PAGE}/pagename.jcr:content.feed"
	"$HOST${PAGE}/pagename.docview.xml"
	"$HOST${PAGE}/pagename.docview.json"
	"$HOST${PAGE}/pagename.sysview.xml"
	"$HOST/etc.xml"
	"$HOST/content.feed.xml"
	"$HOST/content.rss.xml"
	"$HOST/content.feed.html"
	"$HOST/content/add_valid_page.html?debug=layout"
)

echo "***************"
echo "Testing host ${HOST} and sample page ${PAGE}..."
echo "***************"

FAILED=0
CHECKS=0
for URL in "${GET_REQUESTS[@]}"
do
	: 
	RESPONSE=$(curl -o /dev/null --silent --write-out '%{http_code}' "$URL")
	if [[ $RESPONSE -lt 300 && $RESPONSE -ge 200 ]]
	then
		((FAILED+=1))
		echo "PROBLEM: $URL returned response code ${RESPONSE}!"
	fi
	((CHECKED+=1))
done

RESPONSE=$(curl -o /dev/null --silent --write-out '%{http_code}' -X POST "http://anonymous:anonymous@${HOST}/content/usergenerated/mytestnode")
if [[ $RESPONSE -lt 300 && $RESPONSE -ge 200 ]]
then
	((FAILED+=1))
	echo "PROBLEM: POST to $URL returned response code ${RESPONSE}!"
fi
((CHECKED+=1))

RESPONSE=$(curl -o /dev/null --silent --write-out '%{http_code}'  -H "CQ-Handle: ${PATH}" -H "CQ-Path: ${PATH}" "${HOST}/dispatcher/invalidate.cache")
if [[ $RESPONSE -lt 300 && $RESPONSE -ge 200 ]]
then
	((FAILED+=1))
	echo "PROBLEM: Request to dispatcher invalidation returned ${RESPONSE}!"
fi
((CHECKED+=1))


echo "***************"
echo "Tests complete ${FAILED} checks of ${CHECKED} failed"
echo "***************"