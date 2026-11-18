# Infrastructure

**Pick when:** the work decides where and how code runs: runtime, deployment, CI, Nix, networking, secrets, or environments.

The output is the config or module skeleton plus the command that proves it without changing anything live, such as `nix build`, `terraform plan`, a CI dry run, or a container build.

## Decisions to settle

1. The runtime: what runs, where, and as which identity.
2. Environments: which ones exist and what differs between them. Everything else is shared.
3. The trust boundaries: which step holds which secret, and which steps hold none. A step that runs untrusted code never holds a secret.
4. Delivery: how a change reaches each environment, how it is rolled back, and which steps are one-way doors.
5. State: what lives outside the code, such as caches, volumes, and databases, and what happens when it is lost.
6. Reproducibility: pinned versions and inputs, so the same commit builds the same thing.
7. Observability: how you see that it runs, and where the logs go.

## Lenses

- Declarative over imperative. The desired state in code, applied by a tool that converges on it.
- Least privilege per step, not per pipeline.
- Assume anything stored only in a cache will be evicted.
- Prefer what the platform already provides, such as a Nix module, a managed service, or the forge's built-in feature, over new glue.
- Every activation, deploy, or publish is a one-way door. Design it, build it, prove it with a dry run, then ask.
