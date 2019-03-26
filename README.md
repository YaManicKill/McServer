# McServer

My docs and config for my server

I'm using docker for this.

## Usage

* Set up a server using an Alpine Linux image
* Copy this directory onto the server
* Copy a secrets.tar.gz with files in the same structure as this directory into the directory
    * As a minimum, this should include `acme/conf/credentials` file with `dns_digitalocean_token = TOKEN`, where TOKEN is your digital ocean API key
    * This should also include files such as `znc/users/*/networks/*/moddata/nickserv` files and `thelounge/users/*.json`
* `cd` into the directory
* sh ./set-up-host.sh