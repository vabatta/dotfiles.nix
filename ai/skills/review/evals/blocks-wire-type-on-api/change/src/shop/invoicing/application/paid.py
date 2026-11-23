from shop.payments.api import get_charge


def is_paid(charge_id: str) -> bool:
    return get_charge(charge_id)["status"] == "succeeded"
