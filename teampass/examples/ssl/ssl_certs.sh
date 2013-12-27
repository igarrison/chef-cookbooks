#!/bin/bash
#
# Problem: There is all kinds of great web software out there I want to use or to help people setup, but when authentication gets involved you really do want to run https which means getting involved with ssl certificates.  Making certs for each server manually is undesirable.  I may not have a commercially signed ssl certificate ready but still want to get up and running with https.  Ideally it would be nice to support multiple domains and subdomains with a single cert and not have any limitations on the number of servers its distributed to.  We also want to keep the CA cert so client browsers could choose to trust it and not be bothered by chain of trust browser warnings (and the wildcard/SAN names should prevent the annoying cert-name-doesn't-match-browser-name warnings).
#
# Solution: commercial unlimited wildcard ssl certificates can be expensive, even moreso if you want SAN certs supporting multiple wildcard domain names and wildcard subdomain names all in one massive cert.  If you already have a commercial unlimited wildcard ssl certificate that meets your domain needs you do not need this script or self signed certs.  However if you want to get up and running quickly without paying any money lets try and imitate this wildcard+SAN cert strategy but with a single self signed cert to manage in chef.
#
# Purpose: if you have 'openssl' installed on your system this script can generate a single signed wildcard ssl certificate, a key file, and a certificate authority file.  After you edit the certificates_ca/openssl.cnf to set your preferred details you can run the script.  Note that the goal here is to run a *.example.com ssl certificate, and have a number of Subject Alternative Name (SAN) like example.com, *.example.com, *.subdomain.example.com, and *.someotherdomain.com (see the example openssl.cnf). 
#
# Where To Generate Certs: We're using chef to deploy ssl certificates, so we'll just generate them on our own workstation, and once the cert/key/cacert are all uploaded to the chef-server we can wipe/remove it.  Should you ever need to regenerate a cert just run the script again to generate new certs, upload them to the chef-server again, and run chef-client over all servers.   
#
# Where To Use Self Signed Certs: on public facing sites viewed by your customers.  I would prefer also not to have less technical internal/business users having to deal with browser chain of trust warnings at all.  Go buy certs for those things.  These self signed certs are perfect for machines talking to machines, or engineers willing to trust the public cacert so they avoid browser warnings.
#

shopt -s extglob

usage() {
  cat <<EOF
usage: $0 option

OPTIONS:
   help       Show this message
   clean      Clean up
   generate   Generate a Self Signed Wildcard Certificate SSL data bag item
EOF
}

clean() {
  rm -rf server selfsigned_wildcard_ssl_cert.json
  cd certificates_ca
  rm -rf !(openssl.cnf)
}

generate() {
  mkdir -p server certificates_ca/private certificates_ca/certs
  cd certificates_ca
  touch index.txt
  echo 01 > serial

  # setup the CA
  openssl req -x509 -config openssl.cnf -newkey rsa:2048 -days 3550 -out cacert.pem -outform PEM -subj '/C=US/ST=Washington/L=Seattle/O=Example Org/CN=Example Org Root CA/' -nodes
  openssl x509 -in cacert.pem -out cacert.cer -outform DER

  # setup the server cert/key pair, sign with ca cert
  openssl genrsa -out ../server/key.pem 2048
  openssl req -new -key ../server/key.pem -out ../server/req.pem -outform PEM -subj '/C=US/ST=Washington/L=Seattle/O=Example Org/CN=*.example.com/' -nodes
  openssl ca -config openssl.cnf -in ../server/req.pem -out ../server/cert.pem -notext -batch -extensions server_ca_extensions
  cd ../
  ./generate_databag.rb
}

if [ "$1" = "generate" ]; then
  echo "Generating a Self Signed Wildcard SSL Certificate data bag item ..."
  generate
elif [ "$1" = "clean" ]; then
  echo "Cleaning up ..."
  clean
else
  usage
fi
