---
tags: [architect]
max_turns: 25
timeout_seconds: 900
allowed_tools: [Read, Glob, Grep, Skill, Write, Edit, Bash]
---

design adding adyen next to stripe. we want an A/B split per customer, so some customers go through adyen and the rest stay on stripe. the repo has no import boundaries yet, set those up as part of the design too. I'm not around to discuss, go with your best call and leave it uncommitted

Input files: pyproject.toml, src/shop/__init__.py, src/shop/invoicing/application/finalise.py, src/shop/invoicing/application/__init__.py, src/shop/invoicing/__init__.py, src/shop/payments/adapters/__init__.py, src/shop/payments/adapters/stripe_client.py, src/shop/payments/api.py, src/shop/payments/domain/charge.py, src/shop/payments/domain/__init__.py, src/shop/payments/__init__.py
