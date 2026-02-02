# kindctl

`kindctl` is a small, modular CLI that bootstraps a **multi-node local Kubernetes cluster** using [kind](https://kind.sigs.k8s.io/) and Docker.

This repo ships a default topology of **2 control-plane nodes** and **3 worker nodes**, designed to be **simple to run** and **easy to scale** by editing the Kind config.

## What you get

- **2 control-planes + 3 workers** by default (Kind config in `kind/cluster.yaml`)
- Single CLI: **`kindctl`** (cluster lifecycle + kubectl pass-through, like `oc`)
- Put `bin/` on PATH and run `kindctl get pods`, `kindctl up`, etc. from anywhere
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

## Installation

Follow these steps to install and use `kindctl` from anywhere (like `oc` or `kubectl`).

**1. Clone the repo**

```bash
git clone https://github.com/amit-chaubey/kindctl.git
cd kindctl
```

**2. Install prerequisites** (if not already installed)

- Install and start **Docker**: [https://docs.docker.com/get-docker/](https://docs.docker.com/get-docker/)
- Install **kind** and **kubectl**:  
  - macOS: `brew install kind kubectl`  
  - Linux: see [kind install](https://kind.sigs.k8s.io/docs/user/quick-start/#installation) and [kubectl install](https://kubernetes.io/docs/tasks/tools/)

**3. Put `kindctl` on your PATH**

From the repo root, pick one:

```bash
# Option A: this shell only
export PATH="$PATH:$(pwd)/bin"

# Option B: symlink (persists; adjust path if your PATH uses a different dir)
ln -sf "$(pwd)/bin/kindctl" /usr/local/bin/kindctl

# Option C: permanent (e.g. ~/.zshrc or ~/.bashrc)
echo 'export PATH="$PATH:'$(pwd)'/bin"' >> ~/.zshrc
source ~/.zshrc
```

**4. Verify**

```bash
kindctl version
kindctl help
```

You can now run `kindctl` from any directory.

## Quick start

Create the default cluster:

```bash
kindctl up
```

Use kubectl via kindctl (no `export KUBECONFIG` needed):

```bash
kindctl get nodes
kindctl get pods -A
```

Or use kubeconfig directly:

```bash
export KUBECONFIG="$(kindctl kubeconfig)"
kubectl get nodes
```

Delete the cluster:

```bash
kindctl down
```

## Commands

**Cluster lifecycle:**

```bash
kindctl up
kindctl down
kindctl status
kindctl nodes
kindctl kubeconfig
kindctl version
kindctl help
```

**Kubectl pass-through (like OpenShift `oc`):**

```bash
kindctl get pods
kindctl get pods -A
kindctl get nodes -o wide
kindctl apply -f deploy.yaml
kindctl delete pod my-pod
# ... any kubectl subcommand
```

**With a named cluster:**

```bash
kindctl --name dev up
kindctl --name dev get pods
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
- **`kindctl` not found**: add the repo `bin/` to your PATH (see Installation step 3).
- **Old kubeconfig**: `kindctl down` removes the cluster and the `.kube/kubeconfig-<name>` file.

## Repo layout

- `bin/kindctl`: CLI entrypoint
- `scripts/lib/`: shared shell modules (logging, deps, kind operations)
- `kind/cluster.yaml`: Kind cluster definition (2 control-planes + 3 workers)
- `.kube/`: generated kubeconfigs (note: ignored by git)

## License

Apache-2.0. See `LICENSE`.

