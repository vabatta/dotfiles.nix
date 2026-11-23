---
tags: [build]
max_turns: 25
timeout_seconds: 900
allowed_tools: [Read, Glob, Grep, Skill, Write, Edit, Bash]
---

I started the late fee in invoicing (src/shop/invoicing/application/late_fee.py). tests pass but `uv run lint-imports` fails on it. finish it so pytest and the import lint are both green, don't commit

Input files: pyproject.toml, src/shop/__init__.py, src/shop/invoicing/adapters/__init__.py, src/shop/invoicing/application/finalise.py, src/shop/invoicing/application/__init__.py, src/shop/invoicing/application/late_fee.py, src/shop/invoicing/domain/__init__.py, src/shop/invoicing/__init__.py, src/shop/payments/adapters/__init__.py, src/shop/payments/api.py, src/shop/payments/application/__init__.py, src/shop/payments/domain/__init__.py, src/shop/payments/domain/money.py, src/shop/payments/__init__.py, tests/test_late_fee.py
