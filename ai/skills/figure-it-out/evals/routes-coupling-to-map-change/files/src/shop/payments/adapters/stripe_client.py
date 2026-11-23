from shop.payments.domain.charge import Charge


def charge(c: Charge) -> str:
    import stripe

    intent = stripe.PaymentIntent.create(amount=c.amount_cents, currency=c.currency, customer=c.customer_id, confirm=True)
    return intent.id
