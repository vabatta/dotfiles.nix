from shop.invoicing.domain.tier import Tier

DISCOUNT_PERCENT = {Tier.SILVER: 5, Tier.GOLD: 10}


def discount_percent(tier: Tier) -> int:
    return DISCOUNT_PERCENT.get(tier, 0)
