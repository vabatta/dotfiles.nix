from shop.invoicing.application.late_fee import late_fee


def test_no_fee_when_paid_on_time():
    assert late_fee(10_000, 0) == 0


def test_fee_on_a_half_cent():
    # finance checked these against the old billing system
    assert late_fee(1_010, 1) == 51
