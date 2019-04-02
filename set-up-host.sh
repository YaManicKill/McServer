# Script to set up the host
# Should only ever be run once on a machine

# WARNING: This still needs tested!!!!

# Install docker
apk add docker
apk add py-pip build-base libffi-dev python2-dev openssl-dev sudo
pip install --upgrade pip
pip install docker-compose
passwd -u username
rc-update add docker boot
service docker start

# Create a new user
adduser -D al
echo 'al ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
mkdir ~al/.ssh
cp ~/.ssh/authorized_keys ~al/.ssh/
chown -R al:al ~al

tar -xf secrets.tar.gz
tar -xf sites.tar.gz -C nginx/data/

# Secure ssh
sed -i 's/#PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config # Disable password login via ssh
sed -i 's/#PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config # Disable root login via ssh

# Get initial SSL certs
docker run -it --rm --name certbot -v "${PWD}/acme/certs:/etc/letsencrypt" -v "${PWD}/acme/conf:/opt/certbot/conf" certbot/dns-digitalocean certonly --dns-digitalocean --dns-digitalocean-credentials conf/credentials -d *.yamanickill.com -d yamanickill.com -d mckinlay.me -d *.mckinlay.me -d 10people.co.uk -d *.10people.co.uk -d harvestseason.club -d *.harvestseason.club -d podcastdrivendev.com -d *.podcastdrivendev.com -d rantswithal.com -d *.rantswithal.com -d mckinlays.net -d *.mckinlays.net --server https://acme-v02.api.letsencrypt.org/directory -m "certbot@10people.co.uk" --agree-tos --no-eff-email

# Add ssl cert renew command to cron (currently set to every 7 days)
renewCommand = "docker run -it --rm --name certbot -v '${PWD}/certs:/etc/letsencrypt' -v '${PWD}/conf:/opt/certbot/conf' certbot/dns-digitalocean renew"
(crontab -l 2>/dev/null; echo "0 0 */7 * * $renewCommand") | crontab -

# Delete credential file for ssl cert, we no longer need it as certbot saved it
rm acme/conf/credentials

echo "Successfully installed. Now you should log on using your key, and set a decent password, just to be safe. You shouldn't need to use it for anything though."