# Python

**Pick when:** the repo has a `pyproject.toml`, `setup.py`, or `requirements*.txt`, or the change touches `.py` files.

- Find the tool from the repo: `uv.lock` means `uv run` and `uv add`, `poetry.lock` means Poetry, and otherwise follow the README or CI. Take the test, lint, and type commands from `pyproject.toml` or the task runner.
- Prefer the standard library over a dependency: `pathlib`, `dataclasses`, `enum`, `tomllib`, `itertools`, `functools.cache`, `zoneinfo`, `contextlib`, and `asyncio.TaskGroup`.
- Avoid, then use instead:

  | Avoid | Use instead |
  |---|---|
  | `pip install` in a uv project | `uv add` |
  | `os.path` string handling | `pathlib.Path` |
  | `typing.List`, `Optional[X]` | `list[X]`, `X \| None` |
  | a mutable default argument | `None`, then create the value in the body |
  | bare `except:` | the narrowest exception, re-raised with `from err` |

- Type-hint every new public function, and keep the project's type checker passing.
- Write `pytest` tests named for the behavior. Use fixtures over setup code repeated in each test.
