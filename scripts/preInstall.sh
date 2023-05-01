#set env vars
set -o allexport; source .env; set +o allexport;

sed -i "s|DB_PASS_CONF|${ADMIN_PASSWORD}|g" ./config/odoo.conf
sed -i "s|EMAIL_FROM_CONF|${SMTP_FROM_EMAIL}|g" ./config/odoo.conf