from shop.invoicing.application import finalise


def test_finalise_charges_the_total(monkeypatch):
    seen = []
    monkeypatch.setattr(finalise, "charge_customer", lambda c, a, cur: seen.append((c, a, cur)) or "ch_1")
    assert finalise.finalise("inv_1", "cus_1", 1200) == "ch_1"
    assert seen == [("cus_1", 1200, "eur")]
