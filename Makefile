.PHONY: apply config

PROJECT_ID := ""
CLUSTER_NAME := ""

apply:
	kubectl apply --prune --all -f ./gke.yaml

config:
	gcloud container clusters get-credentials ${CLUSTER_NAME} --zone asia-northeast1-a --project ${PROJECT_ID}
