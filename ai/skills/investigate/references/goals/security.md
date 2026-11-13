# Security

**Pick when:** the goal is that less can go wrong if someone tries: secrets, permissions, exposure, dependencies, trust boundaries.

## What to measure
- Secrets in the tree or the history.
- What is reachable: open ports, public endpoints, and who can call them.
- Permissions: CI token scopes, service accounts, file modes, sudo and root use.
- Dependencies with known vulnerabilities, and unpinned ones.
- Trust boundaries: where outside input is used without validation.

## How to measure
- Secrets: `git grep -nIiE '(api[_-]?key|secret|token|passw(or)?d).{0,4}[:=]'` and `git log -p -S'<suspect string>'`.
- Dependencies: `nix shell nixpkgs#osv-scanner --command osv-scanner scan -r .`.
- CI scopes: `git grep -n -A3 'permissions:' -- .github/workflows`, and `gh secret list`.
- Exposure: read firewall rules and listening services in the config, then probe from outside with `curl` or `nc`.

## Typical weak spots
Tokens in scripts or history, CI jobs with write permission they do not need, services bound to all interfaces, shell commands built from input, and credentials shared across machines.

## Evidence that counts
PROVEN: a secret found, a request that succeeds where it should fail, or a scanner hit on a version actually in use. CLAIM: a pattern that could be exploited but was not shown reachable.
