from decimal import ROUND_HALF_EVEN, Decimal


def apply_rate(amount_cents: int, rate: Decimal) -> int:
    return int((Decimal(amount_cents) * rate).quantize(Decimal(1), rounding=ROUND_HALF_EVEN))
