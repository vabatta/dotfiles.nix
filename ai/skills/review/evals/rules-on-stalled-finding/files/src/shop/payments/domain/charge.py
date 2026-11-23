from dataclasses import dataclass


@dataclass(frozen=True)
class Charge:
    customer_id: str
    amount_cents: int
    currency: str
