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

.PHONY: deploy-controller
deploy-controller:
	helmfile sync -l name=arc
	kubectl get pods -n arc-systems

.PHONY: deploy-runner
deploy-runner:
	helmfile sync -l name=$(ARC_RUNNER_NAME)
	until kubectl wait pods -n arc-systems -l actions.github.com/scale-set-name=$(ARC_RUNNER_NAME) --all --for=condition=Ready; do sleep 1; done
	kubectl get pods -n arc-systems

.PHONY: wait-for-job
wait-for-job:
	until kubectl wait pods -n arc-runners -l actions.github.com/scale-set-name=$(ARC_RUNNER_NAME) --all --for=condition=Ready; do sleep 1; done
	kubectl get pods -n arc-runners

# Unregister runners and runner sets from GitHub
.PHONY: undeploy
undeploy:
	kubectl delete -n arc-runners --all AutoscalingRunnerSet

.PHONY: runner-logs
runner-logs:
	-kubectl logs -n arc-runners -l app.kubernetes.io/component=runner --tail=-1 -f

.PHONY: listener-logs
listener-logs:
	-kubectl logs -n arc-systems -l app.kubernetes.io/component=runner-scale-set-listener --tail=-1

.PHONY: controller-logs
controller-logs:
	-kubectl logs -n arc-systems -l app.kubernetes.io/component=controller-manager --tail=-1
