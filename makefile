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
sqlc:
	sqlc generate
test:
	go test -v -cover ./...
.PHONY: postgres createdb dropdb migrateup migratedown sqlc test