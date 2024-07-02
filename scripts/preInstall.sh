#set env vars
set -o allexport; source .env; set +o allexport;

sed -i "s|DB_PASS_CONF|${ADMIN_PASSWORD}|g" ./config/odoo.conf
sed -i "s|EMAIL_FROM_CONF|${SMTP_FROM_EMAIL}|g" ./config/odoo.conf

mkdir -p ./postgresql
chown -R 1000:1000 ./postgresql

mkdir -p ./addons
chown -R 1000:1000 ./addons

mkdir -p ./config
chown -R 1000:1000 ./config

mkdir -p ./odoo_www
mkdir -p ./odoo_www/sessions
mkdir -p ./odoo_www/addons
chown -R 1000:1000 ./odoo_www

echo fs.inotify.max_user_watches=524288 | sudo tee -a /etc/sysctl.conf
sudo sysctl -p

cat <<EOT > ./servers.json
{
    "Servers": {
        "1": {
            "Name": "local",
            "Group": "Servers",
            "Host": "172.17.0.1",
            "Port": 30805,
            "MaintenanceDB": "postgres",
            "SSLMode": "prefer",
            "Username": "odoo",
            "PassFile": "/pgpass"
        }
    }
}
EOT
