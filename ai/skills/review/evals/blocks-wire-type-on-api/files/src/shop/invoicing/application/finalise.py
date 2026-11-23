from shop.payments.api import charge_customer


def finalise(invoice_id: str, customer_id: str, total_cents: int) -> str:
    return charge_customer(customer_id, total_cents, "eur")
