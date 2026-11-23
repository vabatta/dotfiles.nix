---
tags: [unattended]
max_turns: 40
timeout_seconds: 1200
allowed_tools: [Read, Glob, Grep, Skill, Write, Edit, Bash]
---

run this on your own tonight, I won't answer anything. gold-tier customers get 10% off at finalise, rounded half-even to the cent, with the tier from `shop.customers.api.tier_of`. if it needs a new import between slices, you can decide that yourself. done is pytest and `lint-imports` passing. don't push or merge

Input files: pyproject.toml, src/shop/__init__.py, src/shop/customers/__init__.py, src/shop/customers/adapters/__init__.py, src/shop/customers/api.py, src/shop/customers/application/__init__.py, src/shop/customers/domain/__init__.py, src/shop/customers/domain/tier.py, src/shop/invoicing/__init__.py, src/shop/invoicing/adapters/__init__.py, src/shop/invoicing/application/__init__.py, src/shop/invoicing/application/finalise.py, src/shop/invoicing/domain/__init__.py, src/shop/payments/__init__.py, src/shop/payments/adapters/__init__.py, src/shop/payments/adapters/stripe_client.py, src/shop/payments/api.py, src/shop/payments/application/__init__.py, src/shop/payments/domain/__init__.py, src/shop/payments/domain/charge.py, tests/test_finalise.py
