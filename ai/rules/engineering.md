# Engineering rules

Always apply these. The linked skills carry the detail.

- Use nix flakes for every dependency. Never install globally.
- Prefer deletion and the smallest change that solves the problem. **principle-laziness-protocol**
- Delete comments that restate the code. **no-comments**
- Verify the real artifact before declaring done. **principle-prove-it-works**
- Reuse the standard library, dependencies, and existing APIs before writing new code. **principle-use-before-build**
- Encode a recurring correction as a check or script, not more prose. **principle-encode-lessons-in-structure**
- Work in small units that each end in a check. **principle-sequence-verifiable-units**
- Proceed on reversible work without asking; reserve questions for irreversible actions. **principle-never-block-on-the-human**
