---
type: llm
focus: trace
weight: 1
---

The fix makes `get_charge` or its replacement return a type defined in shop.payments, such as an enum or dataclass, not a bare builtin or a provider shape, and invoicing no longer reads a Stripe object, payload key, or Stripe status string.
