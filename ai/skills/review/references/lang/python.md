# Python

**Pick when:** the diff touches `.py` or `pyproject.toml`.

Hunt for what reviewers of Python code most often miss:

- A mutable default argument, such as `def f(x=[])`, shared across calls.
- A bare `except:` or `except Exception` that swallows the error, or a re-raise that drops the cause instead of `raise ... from err`.
- A late-binding closure in a loop that captures the last value of the variable.
- A file, lock, or connection opened without `with`.
- Naive `datetime` values mixed with aware ones. Float money arithmetic.
- Blocking calls inside `async def`, and a coroutine that is never awaited.
- Type hints that lie, such as an `Optional` returned where the hint says it cannot be `None`.
- A dependency added for something the standard library covers, such as `pathlib`, `dataclasses`, `tomllib`, `itertools`, or `functools.cache`.
- A test that never fails: an assertion on a mock's own return value, or `pytest.raises` wrapping more than the call that should raise.
