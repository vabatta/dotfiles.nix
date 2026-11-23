from shop.invoicing.application.late_fee import late_fee


def test_no_fee_when_paid_on_time():
    assert late_fee(10_000, 0) == 0


def test_five_percent_fee_when_late():
    assert late_fee(10_000, 3) == 500
