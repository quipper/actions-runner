KUBECONFIG := kubeconfig.yaml
export KUBECONFIG

.PHONY: cluster
cluster:
	kind create cluster --name arc-cluster
	kubectl version

# Use bash variable expansion to avoid exposing the secrets
.PHONY: create-github-config-secret
create-github-config-secret:
	kubectl create namespace arc-runners
	kubectl create secret generic github-config -n arc-runners \
		"--from-literal=github_app_id=$${APP_ID}" \
		"--from-literal=github_app_installation_id=$${APP_INSTALLATION_ID}" \
		"--from-literal=github_app_private_key=$${APP_PRIVATE_KEY}"

.PHONY: deploy
deploy:
	helmfile sync
	helm list -A
	kubectl get pods -n arc-systems

.PHONY: wait-for-job
wait-for-job:
	while ! kubectl wait pods -n arc-runners -l actions.github.com/scale-set-name=$(ARC_RUNNER_NAME) --all --for=condition=Ready; do sleep 1; done
	while ! kubectl wait pods -n arc-runners -l actions.github.com/scale-set-name=$(ARC_RUNNER_UBUNTU20_NAME) --all --for=condition=Ready; do sleep 1; done
	kubectl get pods -n arc-runners
	-kubectl logs -n arc-runners -l app.kubernetes.io/component=runner --tail=-1 -f

# Unregister runners and runner sets from GitHub
.PHONY: undeploy
undeploy:
	kubectl delete -n arc-runners --all AutoscalingRunnerSet

.PHONY: logs
logs:
	-kubectl logs -n arc-systems -l app.kubernetes.io/component=controller-manager --tail=-1
