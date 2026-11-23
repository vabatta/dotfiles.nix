from decimal import ROUND_HALF_UP, Decimal

LATE_RATE = Decimal("0.05")


def late_fee(total_cents: int, days_late: int) -> int:
    if days_late <= 0:
        return 0
    return int((Decimal(total_cents) * LATE_RATE).quantize(Decimal("1"), rounding=ROUND_HALF_UP))
