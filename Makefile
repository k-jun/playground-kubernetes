PROJECT_ID := ""
CLUSTER_NAME := ""
NETWORK := ""
ZONE := ""

create:
	gcloud --project ${PROJECT_ID} container clusters create ${CLUSTER_NAME} --zone ${ZONE} --network ${NETWORK} --enable-autoprovisioning --max-cpu 10 --max-memory 20

get-credentials:
	gcloud --project ${PROJECT_ID} container clusters get-credentials ${CLUSTER_NAME} --zone ${ZONE}

apply:
	kubectl apply --prune --all -f ./gke.yaml

delete:
	gcloud --project ${PROJECT_ID} container clusters delete ${CLUSTER_NAME} --zone ${ZONE}

