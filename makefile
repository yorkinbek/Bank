postgres:
	docker run --name postgres12 -p 5432:5432 -e POSTGRES_USER=yorqin -e POSTGRES_PASSWORD=yorqinbek -d postgres:12.13-alpine3.17
createdb:
	docker exec -it postgres12 createdb --username=yorqin --owner=yorqin simple_bank
dropdb:
	docker exec -it postgres12 dropdb --username=yorqin simple_bank
migrateup:
	migrate -path db/migration -database "postgresql://yorqin:yorqinbek@localhost:5432/simple_bank?sslmode=disable" -verbose up
migratedown:
	migrate -path db/migration -database "postgresql://yorqin:yorqinbek@localhost:5432/simple_bank?sslmode=disable" -verbose down
migrateup1:
	migrate -path db/migration -database "postgresql://yorqin:yorqinbek@localhost:5432/simple_bank?sslmode=disable" -verbose up 1
migratedown1:
	migrate -path db/migration -database "postgresql://yorqin:yorqinbek@localhost:5432/simple_bank?sslmode=disable" -verbose down 1
sqlc:
	sqlc generate
test:
	go test -v -cover ./...
server:
	go run main.go
mock:
	 mockgen -package mockdb -destination db/mock/store.go github.com/yorqinbek/simple_bank/db/sqlc Store
proto:
	rm -f proto-gen/*.go
	rm -f doc/swagger/*.swagger.json
	protoc --proto_path=proto --go_out=proto-gen --go_opt=paths=source_relative \
    --go-grpc_out=proto-gen --go-grpc_opt=paths=source_relative \
	--grpc-gateway_out=proto-gen --grpc-gateway_opt=paths=source_relative \
	--openapiv2_out=doc/swagger --openapiv2_opt=allow_merge=true,merge_file_name=simple_bank\
    proto/*.proto
	statik -src=./doc/swagger -dest=./doc
evans:
	evans --host localhost --port 9090 -r repl
.PHONY: postgres createdb dropdb migrateup migratedown migrateup1 migratedown1 sqlc test server mock proto evans