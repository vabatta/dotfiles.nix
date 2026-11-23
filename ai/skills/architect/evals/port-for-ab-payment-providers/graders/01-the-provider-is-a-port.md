---
type: llm
focus: trace
weight: 1
---

The design puts the payment provider behind one port with a Stripe adapter and an Adyen adapter, and the per-customer A/B choice sits behind that same interface rather than as a flag checked by callers.
