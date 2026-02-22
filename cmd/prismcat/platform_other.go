//go:build !windows

package main

import (
	"github.com/paopaoandlingyia/PrismCat/internal/config"
	"github.com/paopaoandlingyia/PrismCat/internal/server"
)

func platformRun(srv *server.Server, _ *config.Config, _ bool) error {
	return srv.Start()
}
