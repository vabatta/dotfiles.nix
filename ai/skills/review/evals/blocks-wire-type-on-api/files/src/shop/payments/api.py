from shop.payments.adapters import stripe_client
from shop.payments.domain.charge import Charge


def charge_customer(customer_id: str, amount_cents: int, currency: str) -> str:
    return stripe_client.charge(Charge(customer_id, amount_cents, currency))
