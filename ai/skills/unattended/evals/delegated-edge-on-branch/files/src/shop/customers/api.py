from shop.customers.domain.tier import Tier

_TIERS: dict[str, Tier] = {}


def tier_of(customer_id: str) -> Tier:
    return _TIERS.get(customer_id, Tier.BRONZE)
