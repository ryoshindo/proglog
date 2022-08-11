CONFIG_PATH=/go/src/github.com/ryoshindo/proglog/.proglog/

.PHONY: init
init:
	mkdir -p ${CONFIG_PATH}

.PHONY: gencert
gencert:
	cfssl gencert -initca test/ca-csr.json | cfssljson -bare ${CONFIG_PATH}/ca
	cfssl gencert \
		-ca=${CONFIG_PATH}/ca.pem \
		-ca-key=${CONFIG_PATH}/ca-key.pem \
		-config=test/ca-config.json \
		-profile=server \
		test/server-csr.json | cfssljson -bare ${CONFIG_PATH}/server

	cfssl gencert \
		-ca=${CONFIG_PATH}/ca.pem \
		-ca-key=${CONFIG_PATH}/ca-key.pem \
		-config=test/ca-config.json \
		-profile=client \
		-cn="root" \
		test/client-csr.json | cfssljson -bare ${CONFIG_PATH}/root-client

	cfssl gencert \
		-ca=${CONFIG_PATH}/ca.pem \
		-ca-key=${CONFIG_PATH}/ca-key.pem \
		-config=test/ca-config.json \
		-profile=client \
		-cn="nobody" \
		test/client-csr.json | cfssljson -bare ${CONFIG_PATH}/nobody-client

.PHONY: compile
compile:
	protoc api/v1/*.proto \
		--go_out=. \
		--go-grpc_out=. \
		--go_opt=paths=source_relative \
		--go-grpc_opt=paths=source_relative \
		--proto_path=.

$(CONFIG_PATH)/model.conf:
	cp test/model.conf $(CONFIG_PATH)/model.conf

$(CONFIG_PATH)/policy.csv:
	cp test/policy.csv $(CONFIG_PATH)/policy.csv

.PHONY: test
test: $(CONFIG_PATH)/policy.csv $(CONFIG_PATH)/model.conf
	go test -race ./...
