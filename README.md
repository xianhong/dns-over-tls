# DNS over TLS server



This Docker container implements a [DPRIVE](https://datatracker.ietf.org/wg/dprive/documents/) [RFC 7858](https://datatracker.ietf.org/doc/rfc7858/) server by running [NGINX](nginx.org) as a TLS proxy in front of [ISC BIND](https://www.isc.org/downloads/bind/).

It listens on TCP ports 443 and 853. 

### Reference
This Dockerfile is based on the repo (https://github.com/wkumari/dprive-nginx-bind).



### Build docker image
1. Create a self-signed key pair and put them in a folder

	mkdir certs
	
	openssl req -new -newkey rsa:4096 -x509 -sha256 -days 400 -nodes -out MyCert.crt -keyout MyKey.key 
2. Build the image

	(cd to the directory where Dockerfile is located)
	
	docker build -t dot .


#### Usage
##### Docker
Start:
    (Change working directory to the folder where self-signed key pair is stored)
    docker run -itd --restart always -p 853:853/tcp -v $PWD:/etc/nginx/certificates dot
   
##### Sample client side 'stubby.yml' file that can work with this containerized DNS over TLS server (Assuming server IP is 2.3.4.5)
resolution_type: GETDNS_RESOLUTION_STUB
dns_transport_list:
  - GETDNS_TRANSPORT_TLS
tls_authentication: GETDNS_AUTHENTICATION_NONE
tls_query_padding_blocksize: 128

edns_client_subnet_private : 1
idle_timeout: 10000
listen_addresses:
  - 127.0.0.1@5453

round_robin_upstreams: 0

upstream_recursive_servers:
  - address_data: 2.3.4.5
 
