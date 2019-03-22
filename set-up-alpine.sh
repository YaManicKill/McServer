apk add docker
rc-update add docker boot
service docker start

# Add user?
# Copy digitalocean api credentials
# Disable root ssh

# Ensure we are in the directory of code
docker run -it --rm --name certbot -v "${PWD}/acme/certs:/etc/letsencrypt" -v "${PWD}/acme/conf:/opt/certbot/conf" certbot/dns-digitalocean certonly --dns-digitalocean --dns-digitalocean-credentials conf/credentials -d *.yamanickill.com -d yamanickill.com -d mckinlay.me -d *.mckinlay.me -d 10people.co.uk -d *.10people.co.uk --server https://acme-v02.api.letsencrypt.org/directory -m "certbot@10people.co.uk" --agree-tos --no-eff-email

# Add "docker run -it --rm --name certbot -v "${PWD}/certs:/etc/letsencrypt" -v "${PWD}/conf:/opt/certbot/conf" certbot/dns-digitalocean renew --force-renewal" to cron
# Delete digitalocean api credentials