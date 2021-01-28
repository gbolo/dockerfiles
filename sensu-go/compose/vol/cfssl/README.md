# cfssl - PKI Generator
Simple Makefile for generating PKI quickly

# Usage

### Modify config.sh for server and client certs Common Name and Subject Alternative Names
```
$ vim config.sh
#!/usr/bin/env bash

# SERVERS[CN]=HOSTNAMES
declare -A SERVERS=(
  [sensu.lab.linuxctl.com]="sensu.lab.linuxctl.com,sensu.lab2.linuxctl.com"
  [wild_fabric.linuxctl.com]="localhost,127.0.0.1,ca_peerOrg1,ca_peerOrg2,*.fabric.linuxctl.com,*.org1.fabric.linuxctl.com,*.org1.fabric.linuxctl.com"
)

# CLIENTS[CN]=HOSTNAMES
declare -A CLIENTS=(
  [test_fabric_client1]="fabric_client"
)
```

### Generate Certificates
(make and golang need to be installed)
```
$ make -s all
2017/07/26 22:45:29 [INFO] generating a new CA key and certificate from CSR
2017/07/26 22:45:29 [INFO] generate received request
2017/07/26 22:45:29 [INFO] received CSR
2017/07/26 22:45:29 [INFO] generating key: ecdsa-521
2017/07/26 22:45:29 [INFO] encoded CSR
2017/07/26 22:45:29 [INFO] signed certificate with serial number 442682323006473330206006676946110016441713100516
2017/07/26 22:45:30 [INFO] generating a new CA key and certificate from CSR
2017/07/26 22:45:30 [INFO] generate received request
2017/07/26 22:45:30 [INFO] received CSR
2017/07/26 22:45:30 [INFO] generating key: ecdsa-384
2017/07/26 22:45:30 [INFO] encoded CSR
2017/07/26 22:45:30 [INFO] signed certificate with serial number 216930712504776761154709873247343612224788966915
2017/07/26 22:45:30 [INFO] signed certificate with serial number 612616783188013206631938946327476838394959315747
GENERATING CLIENTS: test_fabric_client1
2017/07/26 22:45:30 [INFO] generate received request
2017/07/26 22:45:30 [INFO] received CSR
2017/07/26 22:45:30 [INFO] generating key: ecdsa-384
2017/07/26 22:45:30 [INFO] encoded CSR
2017/07/26 22:45:30 [INFO] signed certificate with serial number 470430134772785965268081293288554868867659363174
GENERATING SERVER: sensu.lab.linuxctl.com
2017/07/26 22:45:30 [INFO] generate received request
2017/07/26 22:45:30 [INFO] received CSR
2017/07/26 22:45:30 [INFO] generating key: ecdsa-384
2017/07/26 22:45:30 [INFO] encoded CSR
2017/07/26 22:45:30 [INFO] signed certificate with serial number 500258552342695555324567138794973566346472592178
GENERATING SERVER: wild_fabric.linuxctl.com
2017/07/26 22:45:30 [INFO] generate received request
2017/07/26 22:45:30 [INFO] received CSR
2017/07/26 22:45:30 [INFO] generating key: ecdsa-384
2017/07/26 22:45:30 [INFO] encoded CSR
2017/07/26 22:45:30 [INFO] signed certificate with serial number 514689675158596156020722115614298534328575149180
```

### Inspect Certificates
```
$ ls certs/
bundle_ca.pem   ca_root-key.pem                       client_test_fabric_client1-key.pk8.pem   server_sensu.lab.linuxctl.com-key.pk8.pem  server_wild_fabric.linuxctl.com-key.pk8.pem
ca_int.csr      ca_root.pem                           client_test_fabric_client1.pem           server_sensu.lab.linuxctl.com.pem          server_wild_fabric.linuxctl.com.pem
ca_int-key.pem  client_test_fabric_client1-chain.pem  server_sensu.lab.linuxctl.com-chain.pem  server_wild_fabric.linuxctl.com-chain.pem
ca_int.pem      client_test_fabric_client1.csr        server_sensu.lab.linuxctl.com.csr        server_wild_fabric.linuxctl.com.csr
ca_root.csr     client_test_fabric_client1-key.pem    server_sensu.lab.linuxctl.com-key.pem    server_wild_fabric.linuxctl.com-key.pem

$ openssl x509 -in certs/server_wild_fabric.linuxctl.com.pem -text
Certificate:
    Data:
        Version: 3 (0x2)
        Serial Number:
            5a:27:7b:b5:f0:4f:f5:48:06:93:79:64:fb:77:ea:83:8d:b3:44:7c
    Signature Algorithm: ecdsa-with-SHA384
        Issuer: C=CA, ST=Ontario, L=Toronto, O=linuxctl, OU=Lab, CN=linuxctl ECC Certification Authority (Lab)
        Validity
            Not Before: Jul 27 02:41:00 2017 GMT
            Not After : Jul 27 02:41:00 2018 GMT
        Subject: C=CA, ST=Ontario, L=Toronto, O=linuxctl, OU=Lab, CN=wild_fabric.linuxctl.com
        Subject Public Key Info:
            Public Key Algorithm: id-ecPublicKey
                Public-Key: (384 bit)
                pub:
                    04:f5:47:37:50:34:20:7d:06:55:c9:a7:2b:2a:54:
                    5e:11:8a:58:42:a8:ef:19:13:f9:34:ff:3c:2b:37:
                    29:4f:2e:1f:5e:98:b9:08:20:65:22:49:ef:b8:a5:
                    47:71:f0:58:5a:71:ae:5f:91:1d:29:a5:8b:05:b0:
                    24:00:f1:96:d9:cb:83:21:78:8f:ad:43:1d:b6:5c:
                    20:39:5a:b0:7b:82:3a:f0:c5:14:00:64:47:35:15:
                    5c:8c:ca:70:f7:36:ee
                ASN1 OID: secp384r1
                NIST CURVE: P-384
        X509v3 extensions:
            X509v3 Key Usage: critical
                Digital Signature, Key Encipherment
            X509v3 Extended Key Usage:
                TLS Web Server Authentication
            X509v3 Basic Constraints: critical
                CA:FALSE
            X509v3 Subject Key Identifier:
                2A:85:49:6E:7C:18:6D:75:9A:13:2B:42:15:02:84:41:59:DC:54:62
            X509v3 Authority Key Identifier:
                keyid:2A:20:C8:35:9F:C8:70:AA:0B:2A:F6:10:B8:FE:A6:81:51:52:B0:F1

            X509v3 Subject Alternative Name:
                DNS:localhost, DNS:ca_peerOrg1, DNS:ca_peerOrg2, DNS:*.fabric.linuxctl.com, DNS:*.org1.fabric.linuxctl.com, DNS:*.org1.fabric.linuxctl.com, IP Address:127.0.0.1
    Signature Algorithm: ecdsa-with-SHA384
         30:65:02:30:52:97:c7:47:83:87:ef:a9:de:7c:79:1f:c4:47:
         1b:3e:cd:fc:ba:04:b5:e3:3b:e1:b9:c7:03:54:aa:03:37:1b:
         d9:58:8f:3f:66:a0:49:de:a6:8c:ce:65:e1:3e:09:23:02:31:
         00:80:d1:77:26:e8:32:8d:2e:24:19:bb:80:fb:fb:6d:0d:6d:
         a1:19:7e:2e:c9:af:d4:b3:b3:2e:87:dc:5f:8b:51:9c:fb:04:
         9a:84:d6:df:4a:14:a9:ac:4d:73:31:47:a6
```

# Make Targets

```
all (default) - executes targets: clean cfssl ca client server
clean - deletes generated files from certs/
cfssl (requires go) - installs/compiles cfssl binary from github
ca - generates Root and Intermediate CA certs/keys
certs - executes targets: server client
server - generates server certs/keys signed by intermediate CA
client - generates client certs/keys signed by intermediate CA
server-signedbyroot - generates server certs/keys signed by root CA
client-signedbyroot - generates client certs/keys signed by root CA
```

# cfssl docs
https://github.com/cloudflare/cfssl/blob/master/doc/cmd/cfssl.txt

# Safe curves
https://safecurves.cr.yp.to/
