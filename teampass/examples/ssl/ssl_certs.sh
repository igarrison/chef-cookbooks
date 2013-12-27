#!/bin/bash
#
# Credit to Sean Porter (portertech) on the sensu team for this script and the original openssl.cnf which can be found here https://github.com/sensu/sensu-chef/tree/master/examples/ssl.  I have modified it to not make a client certificate, and the openssl.cnf was modified to support wildcard domain names with subject alternative name (multiple domain/subdomain) support.
#
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
