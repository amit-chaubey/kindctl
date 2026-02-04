# kindctl

`kindctl` is a small, modular CLI that bootstraps a **multi-node local Kubernetes cluster** using [kind](https://kind.sigs.k8s.io/) and Docker.

This repo ships a default topology of **2 control-plane nodes** and **3 worker nodes**, designed to be **simple to run** and **easy to scale** by editing the Kind config.

## What you get

- **2 control-planes + 3 workers** by default (Kind config in `kind/cluster.yaml`)
- **`kindctl`** for cluster lifecycle (up, down, status, kubeconfig)
- Use **`kubectl`** for pods, nodes, apply, etc. (set `KUBECONFIG` from `kindctl kubeconfig`)
- Deterministic kubeconfig in `.kube/` (per cluster); Make targets (`make up`, `make down`)

## Prerequisites

- **Docker** — must be installed and running ([Get Docker](https://docs.docker.com/get-docker/))
- **kind** — Kubernetes in Docker ([kind install](https://kind.sigs.k8s.io/docs/user/quick-start/#installation))
- **kubectl** — Kubernetes CLI ([kubectl install](https://kubernetes.io/docs/tasks/tools/))

**macOS (Homebrew):**

```bash
brew install kind kubectl
```

**Linux:** install Docker, then install [kind](https://kind.sigs.k8s.io/docs/user/quick-start/#installation) and [kubectl](https://kubernetes.io/docs/tasks/tools/) per your distro.

---

## Steps in sequence (clone → use)

Run these in order. All commands assume you are in the repo root unless noted.

**1. Install prerequisites** (once per machine)

- Install and start **Docker**: [Get Docker](https://docs.docker.com/get-docker/)
- Install **kind** and **kubectl**:
  - macOS: `brew install kind kubectl`
  - Linux: [kind](https://kind.sigs.k8s.io/docs/user/quick-start/#installation) and [kubectl](https://kubernetes.io/docs/tasks/tools/)

**2. Clone and enter the repo**

```bash
git clone https://github.com/amit-chaubey/kindctl.git
cd kindctl
```

**3. Put `kindctl` on your PATH** (from repo root; pick one)

```bash
# This shell only
export PATH="$PATH:$(pwd)/bin"

# Or symlink (persists)
ln -sf "$(pwd)/bin/kindctl" /usr/local/bin/kindctl

# Or permanent: add to ~/.zshrc or ~/.bashrc then source it
echo 'export PATH="$PATH:'$(pwd)'/bin"' >> ~/.zshrc && source ~/.zshrc
```

**4. Create the cluster** (if a cluster named `kindctl` already exists, this step just ensures kubeconfig and exits)

```bash
kindctl up
```

**5. Use the cluster with kubectl** (pods, nodes, apply, etc.)

```bash
export KUBECONFIG="$(kindctl kubeconfig)"
kubectl get nodes
kubectl get pods -A
```

**6. Optional: check status or delete cluster**

```bash
kindctl status
# When done:
kindctl down
```

## Commands (script reference)

**kindctl** — cluster lifecycle only:

| Command | Description |
|--------|-------------|
| `kindctl up` | Create cluster (or use existing; writes kubeconfig) |
| `kindctl down` | Delete the cluster |
| `kindctl status` | Show cluster exists and node list |
| `kindctl nodes` | List kind node containers |
| `kindctl kubeconfig` | Print kubeconfig path for the cluster |
| `kindctl version` | Print version |
| `kindctl help` | Show usage |

**kubectl** — pods, nodes, apply, delete, etc. (run after `export KUBECONFIG="$(kindctl kubeconfig)"`):

```bash
kubectl get nodes
kubectl get pods -A
kubectl apply -f deploy.yaml
```

**Named cluster** (e.g. `dev`):

```bash
kindctl --name dev up
export KUBECONFIG="$(kindctl --name dev kubeconfig)"
kubectl get nodes
kindctl --name dev down
```

## Configuration

### Change cluster size / roles

Edit `kind/cluster.yaml` and adjust the `nodes:` list. For example:

- Add more workers by appending additional `- role: worker`
- Add more control-planes by appending `- role: control-plane`

### Ingress ports (80/443)

The default config maps container ports **80** and **443** to your host on the first control-plane:

- If ports 80/443 are already used on your machine, change `hostPort` values (or remove the mappings).

## Troubleshooting

- **Docker not running**: start Docker Desktop, then run `kindctl up` again.
- **`kind` not found**: install kind and confirm `kind version` works.
- **`kubectl` not found**: install kubectl and confirm `kubectl version --client` works.
- **`kindctl` not found**: add the repo `bin/` to your PATH (step 3).
- **`kubectl get nodes` fails (connection refused / wrong cluster)**: set the kind kubeconfig first: `export KUBECONFIG="$(kindctl kubeconfig)"` so kubectl uses the kind cluster instead of minikube or another context.
- **Recreate cluster**: run `kindctl down`, then `kindctl up`.

## Repo layout

- `bin/kindctl`: CLI entrypoint
- `scripts/lib/`: shared shell modules (logging, deps, kind operations)
- `kind/cluster.yaml`: Kind cluster definition (2 control-planes + 3 workers)
- `.kube/`: generated kubeconfigs (note: ignored by git)

## License

Apache-2.0. See `LICENSE`.

