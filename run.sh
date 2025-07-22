#!/bin/bash
GITHUB_USERNAME="muerewaf"
GITHUB_EMAIL="fsocietyy@protonmail.com"

SERVICE_NAME=$1
RELEASE_VERSION=$2

echo "Generating Go source code"
mkdir -p golang

protoc --go_out=./golang \
  --go_opt=paths=source_relative \
  --go-grpc_out=./golang \
  --go-grpc_opt=paths=source_relative \
 ./${SERVICE_NAME}/*.proto

echo "Generated Go source code files"
ls -al ./golang/${SERVICE_NAME}

cd golang/${SERVICE_NAME}
go mod init \
  github.com/${GITHUB_USERNAME}/grpc-protos/golang/${SERVICE_NAME} || true
go mod tidy || true
cd ../../
git config --global user.email ${GITHUB_EMAIL}
git config --global user.name ${GITHUB_USERNAME}
git add . && git commit -am "proto update" || true
git push -u origin HEAD
git tag -d golang/${SERVICE_NAME}/${RELEASE_VERSION}
git push --delete origin golang/${SERVICE_NAME}/${RELEASE_VERSION}
git tag -fa golang/${SERVICE_NAME}/${RELEASE_VERSION} \
  -m "golang/${SERVICE_NAME}/${RELEASE_VERSION}"
git push origin refs/tags/golang/${SERVICE_NAME}/${RELEASE_VERSION}