#!/usr/bin/env bash
cp -r 17.0/* ./
docker buildx build . --output type=docker,name=elestio4test/odoo:17.0 | docker load
