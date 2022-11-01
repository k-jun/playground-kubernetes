create:
	gcloud --project ${PROJECT_ID} container clusters create ${CLUSTER_NAME} --zone asia-northeast1-a --network ${NETWORK}

get-credentials:
	gcloud --project ${PROJECT_ID} container clusters get-credentials ${CLUSTER_NAME} --zone asia-northeast1-a

apply:
	kubectl apply --prune --all -f ./gke.yaml

