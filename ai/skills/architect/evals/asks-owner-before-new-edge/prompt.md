---
tags: [architect]
max_turns: 20
timeout_seconds: 1200
allowed_tools: [Read, Glob, Grep, Skill, Write, Edit, Bash]
---

let's design the gold-tier discount at finalise: gold customers get 10% off the invoice total. the tier lives in customers (`shop.customers.api.tier_of`). discuss the shape with me before any code

Input files: pyproject.toml, src/shop/__init__.py, src/shop/customers/__init__.py, src/shop/customers/adapters/__init__.py, src/shop/customers/api.py, src/shop/customers/application/__init__.py, src/shop/customers/domain/__init__.py, src/shop/customers/domain/tier.py, src/shop/invoicing/__init__.py, src/shop/invoicing/adapters/__init__.py, src/shop/invoicing/application/__init__.py, src/shop/invoicing/application/finalise.py, src/shop/invoicing/domain/__init__.py, src/shop/payments/__init__.py, src/shop/payments/adapters/__init__.py, src/shop/payments/adapters/stripe_client.py, src/shop/payments/api.py, src/shop/payments/application/__init__.py, src/shop/payments/domain/__init__.py, src/shop/payments/domain/charge.py, tests/test_finalise.py
