#!/usr/bin/env bash
set -o allexport; source .env; set +o allexport;

sed -i "s~DB_PASS_CONF~${ADMIN_PASSWORD}~g" ./config/odoo.conf

docker-compose up -d;
sleep 30s;