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

.PHONY: controller
controller:
	kustomize build --enable-helm controller | kubectl apply -f - --server-side=true
	until kubectl wait pods -n arc-systems -l app.kubernetes.io/component=controller-manager --all --for=condition=Ready; do sleep 1; done
	kubectl get pods -n arc-systems

.PHONY: runner
runner:
	kustomize build --enable-helm runner | \
		sed \
		-e 's|ARC_RUNNER_NAME|$(ARC_RUNNER_NAME)|g' \
		-e 's|ARC_RUNNER_IMAGE_URI|$(ARC_RUNNER_IMAGE_URI)|g' | \
		kubectl apply -f - --server-side=true

.PHONY: wait-for-runner
wait-for-runner:
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
