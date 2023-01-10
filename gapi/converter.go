package gapi

import (
	db "github.com/yorqinbek/simple_bank/db/sqlc"
	pb "github.com/yorqinbek/simple_bank/proto-gen"
	"google.golang.org/protobuf/types/known/timestamppb"
)

func convertUser(user db.User) *pb.Users {
	return &pb.Users{
		Username:          user.Username,
		FullName:          user.FullName,
		Email:             user.Email,
		PasswordChangedAt: timestamppb.New(user.PasswordChangedAt),
		CreatedAt:         timestamppb.New(user.CreatedAt),
	}
}
