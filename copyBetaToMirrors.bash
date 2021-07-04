#!/usr/bin/env bash

set -e

lbucket=lantern
installerName=lantern-installer
betaBaseName=$installerName-preview
prodBaseName=$installerName


function copyIntallers() {
  files=$(s3cmd ls s3://$lbucket | grep $betaBaseName | grep -v manoto | awk '{print $4}' | xargs basename "$1")
  buckets=(lantern.io getlantern.org 3z8eilzpfmrb8 1k8i3vclry6ml cg3evrbayfebc irn9tm5n7141q 65hok3tx7nwwf 2qcbeehjiqwkc 21p18jyoi2aon urtuz53txrmk9 uf65424cgjtti t7n3kmqsjhgs8 beta.getlantern.org)
  for b in "${buckets[@]}"
  do
    echo "Processing bucket $b"
    for f in $files
    do
      echo "Processing $f"
      prodName=`echo "$f" | sed s/$betaBaseName/$prodBaseName/`
      s3cmd cp s3://$lbucket/$f s3://$b/$prodName
      s3cmd setacl s3://$b/$prodName --acl-public
    done
    s3cmd cp s3://$lbucket/version.txt s3://$b && \
		s3cmd setacl s3://$b/version.txt --acl-public; \
  done
}

copyIntallers
