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

	(Change working directory to where Dockerfile is stored)
	
	docker build -t dot .


### Usage

#### Start:

    (Change working directory to the folder where self-signed key pair is stored)

    docker run -itd --restart always -p 853:853/tcp -v $PWD:/etc/nginx/certificates dot
   
#### Client side confguration:

    'files/stubby.yml' is a sample stubby (DNS over TLS stub) configuration YAML file that works with this containerized DNS over TLS server.

    The IP address of  "2.3.4.5" is for illustrative purpose and  needs to be replaced by actual IP address of the host that the container runs on. 
