#set env vars
set -o allexport; source .env; set +o allexport;

#wait until the server is ready
echo "Waiting for software to be ready ..."
sleep 30s;


if [ -e "./initialized" ]; then
    echo "Already initialized, skipping..."
else
    sed -i 's~proxy_set_header X-Forwarded-Proto \$scheme;~proxy_set_header X-Forwarded-Proto \$scheme;\n    proxy_set_header X-Forwarded-Host \$host;~g' /opt/elestio/nginx/conf.d/${DOMAIN}.conf

    docker exec elestio-nginx nginx -s reload;
    touch "./initialized"
fi


target=$(docker-compose port odoo 8069)

curl http://${target}/web/database/create \
  -H 'accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7' \
  -H 'accept-language: fr-FR,fr;q=0.9,en-US;q=0.8,en;q=0.7,he;q=0.6' \
  -H 'cache-control: max-age=0' \
  -H 'content-type: application/x-www-form-urlencoded' \
  -H 'upgrade-insecure-requests: 1' \
  -H 'user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/112.0.0.0 Safari/537.36' \
  --data-raw 'master_pwd='${ADMIN_PASSWORD}'&name=Odoo&login='${ADMIN_EMAIL}'&password='${ADMIN_PASSWORD}'&phone=&lang=en_US&country_code=' \
  --compressed