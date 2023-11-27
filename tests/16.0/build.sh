#!/usr/bin/env bash
cp -r 16.0/* ./
docker buildx build . --output type=docker,name=elestio4test/odoo:16.0 | docker load
