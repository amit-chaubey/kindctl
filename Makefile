.PHONY: help up down status nodes kubeconfig

CLUSTER_NAME ?= kindctl
KIND_CONFIG ?= kind/cluster.yaml

help:
	@echo "Targets:"
	@echo "  up         Create the kind cluster"
	@echo "  down       Delete the kind cluster"
	@echo "  status     Show cluster status"
	@echo "  nodes      List kind nodes"
	@echo "  kubeconfig Print kubeconfig path"
	@echo ""
	@echo "Examples:"
	@echo "  make up"
	@echo "  CLUSTER_NAME=dev make up"

up:
	@bash ./bin/kindctl up --name "$(CLUSTER_NAME)" --config "$(KIND_CONFIG)"

down:
	@bash ./bin/kindctl down --name "$(CLUSTER_NAME)"

status:
	@bash ./bin/kindctl status --name "$(CLUSTER_NAME)"

nodes:
	@bash ./bin/kindctl nodes --name "$(CLUSTER_NAME)"

kubeconfig:
	@bash ./bin/kindctl kubeconfig --name "$(CLUSTER_NAME)"

