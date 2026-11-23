---
tags: [build]
max_turns: 25
timeout_seconds: 900
allowed_tools: [Read, Glob, Grep, Skill, Write, Edit, Bash]
---

when an invoice is finalised, gold-tier customers should get 10% off the total, rounded half-even to the cent. the tier comes from customers (`shop.customers.api.tier_of`). make pytest and `lint-imports` both green, don't commit

Input files: pyproject.toml, src/shop/customers/adapters/__init__.py, src/shop/customers/api.py, src/shop/customers/application/__init__.py, src/shop/customers/domain/__init__.py, src/shop/customers/domain/tier.py, src/shop/customers/__init__.py, src/shop/__init__.py, src/shop/invoicing/adapters/__init__.py, src/shop/invoicing/application/finalise.py, src/shop/invoicing/application/__init__.py, src/shop/invoicing/domain/__init__.py, src/shop/invoicing/__init__.py, src/shop/payments/adapters/__init__.py, src/shop/payments/adapters/stripe_client.py, src/shop/payments/api.py, src/shop/payments/application/__init__.py, src/shop/payments/domain/charge.py, src/shop/payments/domain/__init__.py, src/shop/payments/__init__.py, tests/test_finalise.py
