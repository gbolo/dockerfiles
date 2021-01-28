SHELL         = /bin/bash
CONFIG        = $(PWD)/config.sh
CFSSL_RELEASE = master
CFSSL	        = env PATH=$(GOPATH)/bin:$(PATH) cfssl
JSON	        = env PATH=$(GOPATH)/bin:$(PATH) cfssljson

all: clean cfssl ca client server

certs: client server

cfssl:
	rm -rf ${GOPATH}/src/github.com/cloudflare/cfssl && mkdir -p ${GOPATH}/src/github.com/cloudflare/cfssl
	curl -L -s https://github.com/cloudflare/cfssl/archive/${CFSSL_RELEASE}.tar.gz | tar xz --strip=1 -C ${GOPATH}/src/github.com/cloudflare/cfssl
	go install github.com/cloudflare/cfssl/cmd/cfssl
	go install github.com/cloudflare/cfssl/cmd/cfssljson

ca:
	mkdir -p certs
	$(CFSSL) gencert -initca config/ca_root-config.json | $(JSON) -bare certs/ca_root
	$(CFSSL) gencert -initca config/ca_int-config.json | $(JSON) -bare certs/ca_int
	$(CFSSL) sign \
		-ca certs/ca_root.pem \
		-ca-key certs/ca_root-key.pem \
		-config config/signing-profiles.json \
		-profile intermediate \
		certs/ca_int.csr | $(JSON) -bare certs/ca_int
	cat certs/ca_int.pem certs/ca_root.pem > certs/bundle_ca.pem

client:
	source $(CONFIG); \
	prepend=client; \
	for i in "$${!CLIENTS[@]}"; do \
		echo "GENERATING CLIENTS: $${i}"; \
		sed "s/PLACEHOLDER/$${i}/" config/csr-generic.json | \
		$(CFSSL) gencert \
			-ca certs/ca_int.pem \
			-ca-key certs/ca_int-key.pem \
			-config config/signing-profiles.json \
			-profile client \
			-hostname "$${CLIENTS[$$i]}" \
			- \
			| $(JSON) -bare certs/$${prepend}_$${i}; \
		cat certs/$${prepend}_$${i}.pem certs/ca_int.pem certs/ca_root.pem > certs/$${prepend}_$${i}-chain.pem; \
		openssl pkcs8 \
			-in certs/$${prepend}_$${i}-key.pem \
			-topk8 \
			-nocrypt \
			-out certs/$${prepend}_$${i}-key.pk8.pem; \
	done

client-signedbyroot:
	source $(CONFIG); \
	prepend=client; \
	for i in "$${!CLIENTS[@]}"; do \
		echo "GENERATING CLIENTS: $${i}"; \
		sed "s/PLACEHOLDER/$${i}/" config/csr-generic.json | \
		$(CFSSL) gencert \
			-ca certs/ca_root.pem \
			-ca-key certs/ca_root-key.pem \
			-config config/signing-profiles.json \
			-profile client \
			-hostname "$${CLIENTS[$$i]}" \
			- \
			| $(JSON) -bare certs/$${prepend}_$${i}; \
		cat certs/client_$${i}.pem certs/ca_root.pem > certs/client_$${i}-chain.pem; \
		openssl pkcs8 \
			-in certs/$${prepend}_$${i}-key.pem \
			-topk8 \
			-nocrypt \
			-out certs/$${prepend}_$${i}-key.pk8.pem; \
	done

server-signedbyroot:
	source $(CONFIG); \
	prepend=server; \
	for i in "$${!SERVERS[@]}"; do \
		echo "GENERATING SERVER: $${i}"; \
		sed "s/PLACEHOLDER/$${i}/" config/csr-generic.json | \
		$(CFSSL) gencert \
			-ca certs/ca_root.pem \
			-ca-key certs/ca_root-key.pem \
			-config config/signing-profiles.json \
			-profile server \
			-hostname "$${SERVERS[$$i]}" \
			- \
			| $(JSON) -bare certs/$${prepend}_$${i}; \
		cat certs/$${prepend}_$${i}.pem certs/ca_root.pem > certs/$${prepend}_$${i}-chain.pem; \
		openssl pkcs8 \
			-in certs/$${prepend}_$${i}-key.pem \
			-topk8 \
			-nocrypt \
			-out certs/$${prepend}_$${i}-key.pk8.pem; \
	done

server-client-signedbyroot:
	source $(CONFIG); \
	prepend=server-client; \
	for i in "$${!SERVERS[@]}"; do \
		echo "GENERATING SERVER-CLIENT: $${i}"; \
		sed "s/PLACEHOLDER/$${i}/" config/csr-generic.json | \
		$(CFSSL) gencert \
			-ca certs/ca_root.pem \
			-ca-key certs/ca_root-key.pem \
			-config config/signing-profiles.json \
			-profile client-server \
			-hostname "$${SERVERS[$$i]}" \
			- \
			| $(JSON) -bare certs/$${prepend}_$${i}; \
		cat certs/$${prepend}_$${i}.pem certs/ca_root.pem > certs/$${prepend}_$${i}-chain.pem; \
		openssl pkcs8 \
			-in certs/$${prepend}_$${i}-key.pem \
			-topk8 \
			-nocrypt \
			-out certs/$${prepend}_$${i}-key.pk8.pem; \
	done

server:
	source $(CONFIG); \
	prepend=server; \
	for i in "$${!SERVERS[@]}"; do \
		echo "GENERATING SERVER: $${i}"; \
		sed "s/PLACEHOLDER/$${i}/" config/csr-generic.json | \
		$(CFSSL) gencert \
			-ca certs/ca_int.pem \
			-ca-key certs/ca_int-key.pem \
			-config config/signing-profiles.json \
			-profile server \
			-hostname "$${SERVERS[$$i]}" \
			- \
			| $(JSON) -bare certs/$${prepend}_$${i}; \
		cat certs/$${prepend}_$${i}.pem certs/ca_int.pem certs/ca_root.pem > certs/$${prepend}_$${i}-chain.pem; \
		openssl pkcs8 \
			-in certs/$${prepend}_$${i}-key.pem \
			-topk8 \
			-nocrypt \
			-out certs/$${prepend}_$${i}-key.pk8.pem; \
	done

clean:
	rm -f ${PWD}/certs/*.csr ${PWD}/certs/*.pem ${PWD}/certs/*.pk8
