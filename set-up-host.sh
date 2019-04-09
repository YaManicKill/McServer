# Script to set up the host
# Should only ever be run once on a machine

# Install docker and docker compose
apt-get update
apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io
curl -L https://github.com/docker/compose/releases/download/1.18.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
docker-compose --version

# Create a new user
adduser --disabled-password al --gecos ""
adduser --disabled-password circleci --gecos ""
echo 'al ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
echo 'circleci ALL=(ALL) NOPASSWD: /usr/bin/rsync' >> /etc/sudoers
mkdir ~al/.ssh
mkdir ~circleci/.ssh
cp ~/.ssh/authorized_keys ~al/.ssh/
chown -R al:al ~al
chown -R circleci:circleci ~circleci

tar -xf secrets.tar.gz --strip-components=1
tar -xf sites.tar.gz -C nginx/data/

# Secure ssh
sed -i 's/#UsePAM.*/UsePAM yes/' /etc/ssh/sshd_config # Allow login without password
sed -i 's/#PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config # Disable password login via ssh
sed -i 's/#PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config # Disable root login via ssh
sed -i 's/PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config # Disable root login via ssh

systemctl restart ssh

# Get initial SSL certs
docker run -it --rm --name certbot -v "${PWD}/acme/certs:/etc/letsencrypt" -v "${PWD}/acme/conf:/opt/certbot/conf" certbot/dns-digitalocean certonly --dns-digitalocean --dns-digitalocean-credentials conf/credentials -d *.yamanickill.com -d yamanickill.com -d mckinlay.me -d *.mckinlay.me -d 10people.co.uk -d *.10people.co.uk -d harvestseason.club -d *.harvestseason.club -d podcastdrivendev.com -d *.podcastdrivendev.com -d rantswithal.com -d *.rantswithal.com -d mckinlays.net -d *.mckinlays.net -d cropbot.club -d *.cropbot.club --server https://acme-v02.api.letsencrypt.org/directory -m "certbot@10people.co.uk" --agree-tos --no-eff-email

# Add ssl cert renew command to cron (currently set to every 7 days)
renewCommand="docker run -it --rm --name certbot -v '${PWD}/certs:/etc/letsencrypt' -v '${PWD}/conf:/opt/certbot/conf' certbot/dns-digitalocean renew"
(crontab -l 2>/dev/null; echo "0 0 */7 * * $renewCommand") | crontab -

# Delete credential file for ssl cert, we no longer need it as certbot saved it
rm acme/conf/credentials

echo "Successfully installed. Now you should log on using your key, and set a decent password, just to be safe. You shouldn't need to use it for anything though."