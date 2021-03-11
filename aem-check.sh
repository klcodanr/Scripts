#!/bin/bash

echo "Enter protocol to use (http or https) and press [ENTER]:"
read PROTOCOL

echo "Enter the domain (without protocol or path) of the website to check and press [ENTER]:"
read DOMAIN

echo "Enter the URL path to a valid page without extension, e.g. /products/product-1 and press [ENTER]:"
read PAGE_PATH

HOST="$PROTOCOL://$DOMAIN"

GET_REQUESTS=(
	"$HOST/admin"
	"$HOST/system/console"
	"$HOST/apps.xml"
	"$HOST/bin/querybuilder.json"
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
	"$HOST/content/screens.exportsearch.csv"
	"$HOST/var/classes.xml"
	"$HOST/system/sling/cqform/defaultlogin.html"
	"$HOST/services/tagfilter"
	"$HOST/services/accesstoken/verify"
	"$HOST/var/linkchecker.html"
	"$HOST/etc/linkchecker.html"
	"$HOST/home/users/a/admin/profile.json"
	"$HOST/home/users/a/admin/profile.xml"
	"$HOST/home/groups/projects/projects-users.permissions.json"
	"$HOST/libs/cq/core/content/login.json"
	"$HOST/content/../libs/foundation/components/text/text.jsp"
	"$HOST/content/.{.}/libs/foundation/components/text/text.jsp"
	"$HOST/apps/sling/config/org.apache.felix.webconsole.internal.servlet.OsgiManager.config/jcr%3acontent/jcr%3adata"
	"$HOST/libs/foundation/components/primary/cq/workflow/components/participants/json.GET.servlet"
	"$HOST${PAGE_PATH}.pages.json"
	"$HOST${PAGE_PATH}.languages.json"
	"$HOST${PAGE_PATH}.blueprint.json"
	"$HOST${PAGE_PATH}.-1.json"
	"$HOST${PAGE_PATH}.10.json"
	"$HOST${PAGE_PATH}.infinity.json"
	"$HOST${PAGE_PATH}.tidy.json"
	"$HOST${PAGE_PATH}.tidy.-1.blubber.json"
	"$HOST${PAGE_PATH}/dam.tidy.-100.json"
	"$HOST/content/geometrixx.sitemap.txt "
	"$HOST${PAGE_PATH}.qu%65ry.js%6Fn?statement=//*"
	"$HOST${PAGE_PATH}.query.json?statement=//*[@transportPassword]/(@transportPassword%20|%20@transportUri%20|%20@transportUser)"
	"$HOST${PAGE_PATH}/_jcr_content.json"
	"$HOST${PAGE_PATH}/jcr:content.json"
	"$HOST${PAGE_PATH}/_jcr_content.feed"
	"$HOST${PAGE_PATH}/jcr:content.feed"
	"$HOST${PAGE_PATH}._jcr_content.feed"
	"$HOST${PAGE_PATH}.jcr:content.feed"
	"$HOST${PAGE_PATH}.docview.xml"
	"$HOST${PAGE_PATH}.docview.json"
	"$HOST${PAGE_PATH}.sysview.xml"
	"$HOST/etc.xml"
	"$HOST/content.feed.xml"
	"$HOST/content.rss.xml"
	"$HOST/content.feed.html"
	"$HOST/content/screens.s7dialog.json"
	"$HOST/is/image"
	"$HOST/${PAGE_PATH}.activity.json"
	"$HOST/services/social/getTranslationProviderInfo"
	"$HOST${PAGE_PATH}.childrenlist.json"
	"$HOST/services/social/datastore/mongo/reindex"
	"$HOST${PAGE_PATH}.blueprint.conf"
	"$HOST${PAGE_PATH}.paragraphs.json"
	"$HOST${PAGE_PATH}.mcmtree.json"
	"$HOST${PAGE_PATH}.offline.json"
	"$HOST${PAGE_PATH}.version.json"
	"$HOST${PAGE_PATH}.offline.doc"
	"$HOST${PAGE_PATH}.media.json"
	"$HOST/services/tagfilter"
	"$HOST/content.s7publish.json"
	"$HOST/services/social/getLoggedInUser"
	"$HOST/api.json"
	"$HOST/system/sling/info"
)

echo "***************"
echo "Testing host ${HOST} and sample page ${PAGE_PATH}..."
echo "***************"

declare -a VALID_CODES
for CODE in 400 401 403 404 401 411
do
    VALID_CODES[$CODE]=1
done

FAILED=0
CHECKS=0
for URL in "${GET_REQUESTS[@]}"
do
	: 
	RESPONSE=$(curl -o /dev/null -g --silent --write-out '%{http_code}' "$URL")
	if [[ ${VALID_CODES[$RESPONSE]} ]]
	then
		echo "GOOD: $URL returned response code ${RESPONSE}"
	else
		((FAILED+=1))
		echo "PROBLEM: $URL returned response code ${RESPONSE}!"
	fi
	((CHECKED+=1))
done

COUNT=$(curl $HOST${PAGE_PATH}.html?debug=layout -s | grep "type\=cq:Page" | wc -l)
if [[ $COUNT -eq 0 ]]
then
	echo "GOOD: ?debug=layout disabled"
else
	((FAILED+=1))
	echo "PROBLEM: debug=layout not disabled!"
fi
((CHECKED+=1))

URL="$PROTOCOL://anonymous:anonymous@${DOMAIN}/content/usergenerated/mytestnode"
RESPONSE=$(curl -o /dev/null --silent --write-out '%{http_code}' -X POST "$URL")
if [[ ${VALID_CODES[$RESPONSE]} ]]
then
	echo "GOOD: POST to $URL returned response code ${RESPONSE}"
else
	((FAILED+=1))
	echo "PROBLEM: POST to $URL returned response code ${RESPONSE}!"
fi
((CHECKED+=1))

RESPONSE=$(curl -o /dev/null --silent --write-out '%{http_code}'  -H "CQ-Handle: ${PATH}" -H "CQ-Path: ${PATH}" "$PROTOCOL://${DOMAIN}/dispatcher/invalidate.cache")
if [[ ${VALID_CODES[$RESPONSE]} ]]
then
	echo "GOOD: Request to dispatcher invalidation returned  ${RESPONSE}"
else
	((FAILED+=1))
	echo "PROBLEM: Request to dispatcher invalidation returned ${RESPONSE}!"
fi
((CHECKED+=1))


echo "***************"
echo "Tests complete ${FAILED} checks of ${CHECKED} failed"
echo "***************"