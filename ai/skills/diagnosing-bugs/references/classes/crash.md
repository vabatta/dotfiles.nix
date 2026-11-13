# Crash or error

**Pick when:** the failure is deterministic: the same input gives the same exception, stack trace, wrong exit code, or wrong output every time.

## Build the loop
- Turn the exact failing call into a test or a one-line command that asserts the symptom: the exception type and message, the exit code, or a diff against the expected output.
- Start from the stack trace's deepest frame in your own code and build the loop at that seam, not at the top of the app.
- Capture the input that triggers it (request body, file, arguments) into a fixture, redacted.

## Narrow it
- Minimise the input: halve it until it no longer fails, then keep the last failing half.
- Read the frames between the entry point and the throw. The bug is usually where a value first becomes wrong, not where it throws.
- Assert the intermediate values at each boundary in the trace, one probe per boundary.

## Typical root causes
Null or empty values at a boundary, a wrong type or unit, an unhandled branch in a parser or switch, an off-by-one, a changed API contract upstream.

## Proof of fix
The fixture test goes red before the fix and green after, and the original un-minimised input passes.
