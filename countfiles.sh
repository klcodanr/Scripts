#!/bin/bash
echo "Extension,File Count,Lines"
for EXTENSION in $(find .  -path ./.git -prune -o -type f | perl -ne 'print $1 if m/\.([^.\/]+)$/' | sort -u)
do
  COUNT=$(find ./ -name "*.${EXTENSION}" | wc -l | xargs) 
  LINES=$(( find ./ -name "*.${EXTENSION}" -print0 | xargs -0 cat 2>/dev/null  ) | wc -l | xargs)
  echo "${EXTENSION},${COUNT},${LINES}"
done
