#!/usr/bin/env sh

apk add bash

echo "INIT THE BACKEND ADMIN CREDENTIALS..."
sensu-backend init \
  --cluster-admin-username="admin" \
  --cluster-admin-password='P@ssw0rd!' \
  --etcd-trusted-ca-file=/opt/tls/ca_root.pem \
  --etcd-cert-file=/opt/tls/client_etcd.pem \
  --etcd-key-file=/opt/tls/client_etcd-key.pem \
  --etcd-advertise-client-urls=https://etcd1.sensu.dev:2379,https://etcd2.sensu.dev:2379,https://etcd3.sensu.dev:2379

echo "CONFIGURE SENSUCTL..."
sensuctl configure --non-interactive \
  --username admin --password 'P@ssw0rd!' \
  --url 'https://backend.sensu.dev:8080' \
  --trusted-ca-file /opt/tls/ca_root.pem

/opt/sensu/scripts/create_resources.sh /opt/sensu/resources

echo "SLEEPING NOW..."
sleep 6000
