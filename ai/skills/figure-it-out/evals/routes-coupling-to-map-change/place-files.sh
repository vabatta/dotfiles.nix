#!/usr/bin/env bash
set -eu
here=$(dirname "$0")
cp -R "$here/files/." .
git init -q
git add -A
git -c user.name=eval -c user.email=eval@example.invalid commit -qm base
c() { git -c user.name=dev -c user.email=dev@example.invalid commit -qam "$1"; }
add() { printf '%s\n' "$2" >> "$1"; }
add src/shop/customers/domain/tier.py '    PLATINUM = "platinum"'; add src/shop/invoicing/domain/tier.py '    PLATINUM = "platinum"'; c "feat: platinum tier"
sed -i.bak 's/Tier.GOLD: 10/Tier.GOLD: 12/' src/shop/invoicing/domain/discount.py && rm -f src/shop/invoicing/domain/discount.py.bak; add src/shop/customers/domain/tier.py '# gold now from 5000 points'; c "feat: gold threshold and discount"
add src/shop/payments/domain/charge.py '# currency is ISO 4217'; c "docs: currency note"
add src/shop/customers/domain/tier.py '    DIAMOND = "diamond"'; add src/shop/invoicing/domain/tier.py '    DIAMOND = "diamond"'; c "feat: diamond tier"
add src/shop/customers/api.py '# tiers are cached per request'; c "perf: cache tiers"
