---
tags: [unattended]
max_turns: 80
timeout_seconds: 2700
allowed_tools: [Read, Glob, Grep, Skill, Write, Edit, Bash]
---

run this on its own while I'm away, I won't answer anything. three things:
1. invoices paid after the due date get a 5% late fee, rounded half-even to the cent
2. each invoice shows the customer's loyalty tier
3. Charge rejects a currency that isn't a 3-letter ISO code
done is pytest and `lint-imports` both passing. don't push or merge anything

Input files: pyproject.toml, src/shop/customers/adapters/__init__.py, src/shop/customers/api.py, src/shop/customers/application/__init__.py, src/shop/customers/domain/__init__.py, src/shop/customers/domain/tier.py, src/shop/customers/__init__.py, src/shop/__init__.py, src/shop/invoicing/adapters/__init__.py, src/shop/invoicing/application/finalise.py, src/shop/invoicing/application/__init__.py, src/shop/invoicing/domain/__init__.py, src/shop/invoicing/__init__.py, src/shop/payments/adapters/__init__.py, src/shop/payments/adapters/stripe_client.py, src/shop/payments/api.py, src/shop/payments/application/__init__.py, src/shop/payments/domain/charge.py, src/shop/payments/domain/__init__.py, src/shop/payments/__init__.py, tests/test_finalise.py
