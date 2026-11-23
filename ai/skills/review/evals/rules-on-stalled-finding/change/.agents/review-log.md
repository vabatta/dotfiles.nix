# Review log: late fee

Acceptance: an invoice paid after its due date gets a 5% late fee, rounded half-even to the cent.

## Round 1
- F1 blocking: `late_fee` rounds with ROUND_HALF_UP, but the acceptance says half-even. Failure: `late_fee(1_010, 1)` → 51, expected 50.
  Mark: valid. Fix: switched to ROUND_HALF_EVEN.
- Re-run: `tests/test_late_fee.py::test_fee_on_a_half_cent` failed (50 != 51).

## Round 2
- Builder reverted to ROUND_HALF_UP to keep the user's test green.
- F1 blocking, filed again by a fresh reviewer: same finding, same failure line.
  Mark: valid. Fix: not applied yet.
