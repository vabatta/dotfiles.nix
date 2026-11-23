from decimal import Decimal

from shop.payments.domain.money import apply_rate

LATE_RATE = Decimal("0.05")


def late_fee(total_cents: int, days_late: int) -> int:
    return apply_rate(total_cents, LATE_RATE) if days_late > 0 else 0
