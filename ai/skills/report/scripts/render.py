#!/usr/bin/env python3
"""Render a work report: render.py <data.json> <out.html> [repo]. Stdlib only."""
import html
import json
import os
import re
import shutil
import subprocess
import sys
import tempfile

STATUS = {"VERIFIED": "ok", "NOT VERIFIED": "bad", "INCONCLUSIVE": "warn"}
CONF = {"low": 0, "medium": 1, "high": 2}
TONE = {"low": "bad", "medium": "warn", "high": "ok"}
SEV = {"high": "bad", "medium": "warn", "low": "muted"}
AGENT = ".agent/"
SLASH = re.compile(r"(?<![\w/.])/([a-z][a-z0-9-]*)(?![\w/-])(?!\.\w)")
MERMAID = "https://cdn.jsdelivr.net/npm/mermaid@11.4.1/dist/mermaid.esm.min.mjs"
WORDS = re.compile(r"\b(should|would|could|may|might|has been|have been)\b|;|n't\b", re.I)

CSS = """
:root{--bg:0 0% 100%;--fg:240 10% 3.9%;--muted:240 4.8% 95.9%;--mfg:240 3.8% 46.1%;--line:240 5.9% 90%;--r:.5rem;
--ok-bg:142 76% 91%;--ok-fg:142 72% 24%;--bad-bg:0 93% 94%;--bad-fg:0 70% 35%;--warn-bg:48 96% 89%;--warn-fg:26 83% 28%;--add:142 70% 94%;--del:0 86% 95%}
@media(prefers-color-scheme:dark){:root{--bg:240 10% 3.9%;--fg:0 0% 98%;--muted:240 3.7% 15.9%;--mfg:240 5% 64.9%;--line:240 3.7% 15.9%;
--ok-bg:142 60% 12%;--ok-fg:142 70% 70%;--bad-bg:0 60% 16%;--bad-fg:0 90% 78%;--warn-bg:35 70% 14%;--warn-fg:45 93% 70%;--add:142 40% 13%;--del:0 40% 15%}}
*{box-sizing:border-box}
body{margin:0;background:hsl(var(--bg));color:hsl(var(--fg));font:14px/1.6 ui-sans-serif,system-ui,-apple-system,"Segoe UI",sans-serif;-webkit-font-smoothing:antialiased}
main{max-width:960px;margin:0 auto;padding:0 16px 64px}
nav{position:sticky;top:0;z-index:5;display:flex;flex-wrap:wrap;gap:4px;align-items:center;padding:10px 0;background:hsl(var(--bg)/.85);backdrop-filter:blur(8px);border-bottom:1px solid hsl(var(--line))}
nav a,button:not(.pb){padding:4px 10px;border-radius:calc(var(--r) - 2px);color:hsl(var(--mfg));text-decoration:none;font-size:13px;font-weight:500;font-family:inherit}
nav a:hover,button:not(.pb):hover{background:hsl(var(--muted));color:hsl(var(--fg))}
button:not(.pb){margin-left:auto;border:1px solid hsl(var(--line));background:none;cursor:pointer}
h1{font-size:30px;line-height:1.2;letter-spacing:-.02em;margin:28px 0 8px}
h2{font-size:18px;letter-spacing:-.01em;margin:36px 0 12px;scroll-margin-top:56px}
p{margin:0}.lead{color:hsl(var(--mfg));font-size:16px}.eyebrow{color:hsl(var(--mfg));font-size:12px;font-weight:500;text-transform:uppercase;letter-spacing:.06em}
code{font:12px ui-monospace,SFMono-Regular,Menlo,monospace;background:hsl(var(--muted));padding:1px 5px;border-radius:4px}
.grid{display:grid;grid-template-columns:repeat(auto-fit,minmax(190px,1fr));gap:12px;margin:24px 0}
.card{border:1px solid hsl(var(--line));border-radius:var(--r);box-shadow:0 1px 2px hsl(240 6% 10%/.05);overflow:hidden}
.stat{padding:16px}.k{color:hsl(var(--mfg));font-size:13px;font-weight:500}.v{font-size:28px;font-weight:700;letter-spacing:-.02em;line-height:1.3}.s{font-size:12px;color:hsl(var(--mfg))}
.callout{padding:14px 16px;border-left:3px solid hsl(var(--fg))}.callout b{display:block;font-size:12px;text-transform:uppercase;letter-spacing:.06em;color:hsl(var(--mfg))}
ul{margin:0;padding-left:20px}li{margin:4px 0}.list{padding:12px 16px 12px 20px}.todo{list-style:none;padding:12px 16px}.todo li{position:relative;padding-left:26px}
.todo li::before{content:"";position:absolute;left:0;top:4px;width:14px;height:14px;border:1.5px solid hsl(var(--mfg));border-radius:4px}
.wrap{overflow-x:auto}table{width:100%;border-collapse:collapse}
th{text-align:left;color:hsl(var(--mfg));font-weight:500;font-size:12px;padding:10px 16px;border-bottom:1px solid hsl(var(--line));background:hsl(var(--muted)/.5)}
td{padding:10px 16px;border-bottom:1px solid hsl(var(--line));vertical-align:top}tr:last-child td{border-bottom:0}
.badge{display:inline-block;padding:1px 9px;border-radius:9999px;font-size:12px;font-weight:600;white-space:nowrap}
.ok{background:hsl(var(--ok-bg));color:hsl(var(--ok-fg))}.bad{background:hsl(var(--bad-bg));color:hsl(var(--bad-fg))}
.warn{background:hsl(var(--warn-bg));color:hsl(var(--warn-fg))}.muted{background:hsl(var(--muted));color:hsl(var(--mfg))}
details.step{margin-bottom:10px}summary{list-style:none;cursor:pointer;display:flex;gap:10px;align-items:center;padding:12px 16px;font-weight:600}
summary::-webkit-details-marker{display:none}summary::after{content:"";margin-left:4px;width:7px;height:7px;border:solid hsl(var(--mfg));border-width:0 1.5px 1.5px 0;transform:rotate(45deg);flex:none}
details[open]>summary::after{transform:rotate(-135deg)}summary:hover{background:hsl(var(--muted)/.5)}
.num{flex:none;width:24px;height:24px;border-radius:9999px;background:hsl(var(--muted));text-align:center;line-height:24px;font-size:12px}
.meta{font:12px ui-monospace,monospace;color:hsl(var(--mfg));font-weight:400}.meta .a{color:hsl(var(--ok-fg))}.meta .d{color:hsl(var(--bad-fg))}.ttl{flex:1}summary>.meta:last-child{margin-left:auto}
.body{padding:0 16px 16px}.body>p{margin-bottom:8px}.alert{display:flex;gap:8px;align-items:baseline;margin:8px 0;padding:8px 12px;border:1px solid hsl(var(--line));border-radius:var(--r)}
details.file{border-top:1px solid hsl(var(--line));margin:8px -16px 0}details.file>summary{padding:8px 16px;font-weight:400}
pre{margin:0;overflow:auto;max-height:420px;font:12px/1.5 ui-monospace,SFMono-Regular,Menlo,monospace;border-top:1px solid hsl(var(--line))}
figure{margin:0 0 12px}figcaption{padding:10px 16px;border-top:1px solid hsl(var(--line));font-size:13px;color:hsl(var(--mfg))}figcaption b{color:hsl(var(--fg))}
pre.mermaid{max-height:none;border:0;padding:16px;display:flex;justify-content:center;white-space:pre;font-size:12px}
.diff span{display:block;padding:0 16px;white-space:pre;min-width:max-content}.add{background:hsl(var(--add))}.del{background:hsl(var(--del))}.hunk{color:hsl(var(--mfg))}
.note{color:hsl(var(--mfg));font-size:12px;margin-top:12px}
button.pb{margin:0;padding:1px 9px;border:0;font-family:inherit;cursor:pointer}button.pb::after{content:" \\25BE"}button.pb:hover{filter:brightness(.95)}
.pop{position:fixed;inset:auto;margin:0;width:min(320px,calc(100vw - 16px));padding:12px 14px;border:1px solid hsl(var(--line));border-radius:var(--r);background:hsl(var(--bg));color:hsl(var(--fg));box-shadow:0 8px 24px hsl(240 6% 10%/.18);font-size:13px}
@supports not selector(:popover-open){.pop{display:none}}
.nx{padding:14px 16px;margin-bottom:10px}.nh{display:flex;align-items:center}.nx p{color:hsl(var(--mfg));margin:4px 0 10px}
pre.prompt{max-height:none;border:1px solid hsl(var(--line));border-radius:calc(var(--r) - 2px);padding:10px 12px;white-space:pre-wrap;background:hsl(var(--muted)/.5)}
.cmd{font-weight:700;background:hsl(var(--muted));padding:0 4px;border-radius:4px}
"""

SCRIPT = """const b=document.getElementById("tog"),s=[...document.querySelectorAll("details.step")];
b.onclick=()=>{const o=!s.every(d=>d.open);s.forEach(d=>d.open=o);b.textContent=o?"Collapse all":"Expand all"}
document.addEventListener("click",async e=>{const c=e.target.closest("[data-copy]");if(!c)return;const x=c.closest(".nx").querySelector("pre").textContent;let ok=false;
try{await navigator.clipboard.writeText(x);ok=true}catch(_){const a=document.createElement("textarea");a.value=x;document.body.append(a);a.select();try{ok=document.execCommand("copy")}catch(_){}a.remove()}
c.textContent=ok?"Copied":"Copy failed";setTimeout(()=>c.textContent="Copy",1500)})
document.addEventListener("toggle",e=>{const p=e.target;if(!p.classList.contains("pop")||!p.matches(":popover-open"))return;
const r=document.querySelector(`[popovertarget="${p.id}"]`).getBoundingClientRect();
p.style.top=r.bottom+6+"px";p.style.left=Math.max(8,Math.min(r.right-p.offsetWidth,innerWidth-p.offsetWidth-8))+"px"},true)"""


def t(v):
    return html.escape(str(v))


def md(v):
    parts = html.escape(str(v)).split("`")
    return "".join(f"<code>{p}</code>" if i % 2 else p for i, p in enumerate(parts))


def git(repo, *args):
    r = subprocess.run(["git", "-C", repo, *args], capture_output=True, encoding="utf-8", errors="replace")
    if r.returncode:
        sys.exit("git " + " ".join(args) + ": " + r.stderr.strip())
    return r.stdout


def names_of(out):
    return [n for n in out.split("\0") if n]


def need(d, key, kind):
    if not isinstance(d.get(key), kind):
        sys.exit(f"data.{key}: expected {kind.__name__}")
    return d[key]


def objects(d, key):
    items = need(d, key, list)
    for i in items:
        if not isinstance(i, dict):
            sys.exit(f"data.{key}: every item must be an object, got {i!r}")
    return items


def prose(o):
    if isinstance(o, str):
        yield o
    elif isinstance(o, list):
        for x in o:
            yield from prose(x)
    elif isinstance(o, dict):
        for k, v in o.items():
            if k not in ("base", "files", "status", "confidence", "severity", "mermaid"):
                yield from prose(v)


def style_warnings(d):
    for text in prose(d):
        for sent in re.split(r"(?<=[.!?])\s+", text):
            plain = re.sub(r"`[^`]*`", "X", sent)
            if len(plain.split()) > 25 or WORDS.search(plain):
                yield sent[:80]


def skill_warnings(repo, d):
    roots = [os.path.join(repo, "ai/skills"), os.path.join(repo, ".claude/skills"), os.path.expanduser("~/.claude/skills")]
    for n in d.get("next", []):
        for name in SLASH.findall(n.get("prompt", "")):
            if not any(os.path.isdir(os.path.join(r, name)) for r in roots):
                yield f"unknown skill /{name}"


def cmd(prompt):
    return SLASH.sub(lambda m: f'<b class="cmd">/{m[1]}</b>', t(prompt))


def check_diagram(src):
    exe = shutil.which("validate-mermaid")
    if not exe:
        print("diagram not validated: validate-mermaid is not on PATH", file=sys.stderr)
        return
    r = subprocess.run([exe], input=src, capture_output=True, encoding="utf-8")
    if r.returncode:
        sys.exit("diagram does not parse: " + r.stderr.strip())


def confidence(x, i):
    label, tone, why = x["confidence"], TONE[x["confidence"]], x.get("confidence_why")
    if not why:
        return badge(label, tone)
    return (f'<button class="badge {tone} pb" popovertarget="cw{i}">{label}</button>'
            f'<div id="cw{i}" popover class="pop">{md(why)}</div>')


def badge(text, tone):
    return f'<span class="badge {tone}">{t(text)}</span>'


def counts(a, r):
    return f'<span class="meta"><span class="a">+{a}</span> <span class="d">&minus;{r}</span></span>'


def table(head, rows):
    th = "".join(f"<th>{h}</th>" for h in head)
    tr = "".join("<tr>" + "".join(f"<td>{c}</td>" for c in r) + "</tr>" for r in rows)
    return f'<div class="card wrap"><table><tr>{th}</tr>{tr}</table></div>'


def section(sid, title, inner):
    return f'<section id="{sid}"><h2>{title}</h2>{inner}</section>'


def stat(k, v, sub):
    return f'<div class="card stat"><div class="k">{k}</div><div class="v">{v}</div><div class="s">{sub}</div></div>'


def diff_html(text):
    cls = {"+": "add", "-": "del", "@": "hunk"}
    return "".join(f'<span class="{cls.get(l[:1], "")}">{html.escape(l)}</span>' for l in text.splitlines())


def main():
    src, out = sys.argv[1], sys.argv[2]
    d = json.load(open(src))
    if not isinstance(d, dict):
        sys.exit("data: expected an object")
    for k in ("title", "goal", "done_predicate", "base"):
        need(d, k, str)
    landed, verified, decisions, steps = (objects(d, k) for k in ("landed", "verified", "decisions", "steps"))
    opened, highlights = need(d, "open", list), need(d, "highlights", list)
    base, budget = d["base"], d.get("budget")
    if base.startswith("-"):
        sys.exit("base must be a revision, not an option: " + base)
    if budget is not None and (isinstance(budget, bool) or not isinstance(budget, int)):
        sys.exit("data.budget: expected an integer or null")
    repo = git(sys.argv[3] if len(sys.argv) > 3 else ".", "rev-parse", "--show-toplevel").strip()

    fresh = names_of(git(repo, "ls-files", "-o", "--exclude-standard", "-z"))
    fd, idx = tempfile.mkstemp()
    os.close(fd)
    shutil.copy(os.path.join(repo, git(repo, "rev-parse", "--git-path", "index").strip()), idx)
    os.environ["GIT_INDEX_FILE"] = idx
    if fresh:
        subprocess.run(["git", "-C", repo, "add", "-N", "--pathspec-from-file=-", "--pathspec-file-nul"], input="\0".join(fresh), check=True, encoding="utf-8")
    names = names_of(git(repo, "diff", "--no-renames", "--name-only", "-z", base, "--"))
    if not names:
        sys.exit("empty diff against " + base)
    seen = {}
    for s in steps:
        files = s.get("files", [])
        if not isinstance(files, list) or not all(isinstance(f, str) for f in files):
            sys.exit(f"step files must be a list of paths: {files!r}")
        for f in files:
            if f in seen:
                sys.exit(f"{f}: listed in two steps")
            seen[f] = s
        if not isinstance(s.get("summary"), str) or not isinstance(s.get("changes"), list):
            sys.exit(f"step needs a summary string and a changes list: {s.get('title')!r}")
    gap = [n for n in names if n not in seen and not n.startswith(AGENT)]
    extra = [f for f in seen if f not in names]
    if gap or extra:
        sys.exit(f"steps must cover the diff exactly. missing: {gap} not in diff: {extra}")
    for v in verified:
        if v.get("status") not in STATUS:
            sys.exit(f"verified status must be one of {sorted(STATUS)}: {v}")
    for x in decisions:
        if x.get("confidence") not in CONF:
            sys.exit(f"decision confidence must be low, medium, or high: {x}")
    for s in steps:
        findings = s.get("findings", [])
        if not isinstance(findings, list) or not all(isinstance(f, dict) and f.get("severity") in SEV for f in findings):
            sys.exit(f"step findings must be objects with severity high, medium, or low: {findings!r}")

    diagrams = d.get("diagrams", [])
    if not isinstance(diagrams, list) or not all(isinstance(g, dict) and isinstance(g.get("title"), str) and isinstance(g.get("mermaid"), str) for g in diagrams):
        sys.exit("data.diagrams: expected a list of objects with a title and a mermaid string")
    for g in diagrams:
        check_diagram(g["mermaid"])
    nxt = d.get("next", [])
    if not isinstance(nxt, list) or not all(isinstance(n, dict) and all(isinstance(n.get(k), str) for k in ("title", "why", "prompt")) for n in nxt):
        sys.exit("data.next: expected a list of objects with title, why, and prompt strings")
    warned = list(style_warnings(d)) + list(skill_warnings(repo, d))
    for w in warned:
        print("style: " + w, file=sys.stderr)
    stats = {}
    for rec in names_of(git(repo, "diff", "--no-renames", "--numstat", "-z", base, "--")):
        a, r, path = rec.split("\t", 2)
        stats[path] = (0, 0) if a == "-" else (int(a), int(r))
    counted = [p for p in stats if not p.startswith(AGENT)]
    add, dele = sum(stats[p][0] for p in counted), sum(stats[p][1] for p in counted)
    net = add - dele
    over = budget is not None and net > budget
    agent_files = [n for n in names if n.startswith(AGENT)]
    tally = {k: sum(v["status"] == k for v in verified) for k in STATUS}
    low = sum(x["confidence"] == "low" for x in decisions)

    budget_sub = "no budget stated" if budget is None else f"budget {budget}" + (" (over)" if over else "")
    cards = "".join([
        stat("Files changed", len(counted), f"+{add} &minus;{dele}, net {net:+d}, {budget_sub}"),
        stat("Checks passed", f"{tally['VERIFIED']}/{len(verified)}", f"{tally['NOT VERIFIED']} not verified, {tally['INCONCLUSIVE']} inconclusive"),
        stat("Decisions", len(decisions), f"{low} with low confidence"),
        stat("Open items", len(opened), "see the list below"),
    ])
    ranked = sorted(decisions, key=lambda x: CONF[x["confidence"]])
    note = '<p class="note">Click a confidence badge to see the reason for it.</p>' if any(x.get("confidence_why") for x in ranked) else ""
    body = [
        f'<p class="eyebrow">Work report &middot; base <code>{t(base)}</code></p><h1>{t(d["title"])}</h1><p class="lead">{md(d["goal"])}</p>',
        f'<div class="grid">{cards}</div>',
        f'<div class="card callout"><b>Done when</b>{md(d["done_predicate"])}</div>',
        section("summary", "At a glance", '<div class="card list"><ul>' + "".join(f"<li>{md(h)}</li>" for h in highlights) + "</ul></div>"),
        *([section("diagrams", "Diagrams", "".join(
            f'<figure class="card"><pre class="mermaid">{t(g["mermaid"])}</pre><figcaption><b>{t(g["title"])}</b> {md(g.get("caption", ""))}</figcaption></figure>'
            for g in diagrams))] if diagrams else []),
        section("landed", "What landed", table(["Unit", "Result", "Evidence"],
            [(md(u.get("unit", "")), md(u.get("result", "")), md(u.get("evidence", ""))) for u in landed])),
        section("verified", "Checks", table(["Claim", "Status", "Evidence"],
            [(md(v.get("claim", "")), badge(v["status"], STATUS[v["status"]]), md(v.get("evidence", ""))) for v in verified])),
        section("decisions", "Decisions, least confident first", table(["Decision", "Why", "Confidence"],
            [(md(x.get("decision", "")), md(x.get("why", "")), confidence(x, i)) for i, x in enumerate(ranked)]) + note),
        section("open", "Still open", '<div class="card"><ul class="todo">' + "".join(f"<li>{md(o)}</li>" for o in opened) + "</ul></div>"),
        *([section("next", "Follow-up prompts", "".join(
            f'<div class="card nx"><div class="nh"><b>{t(n["title"])}</b><button data-copy>Copy</button></div><p>{md(n["why"])}</p><pre class="prompt">{cmd(n["prompt"])}</pre></div>'
            for n in nxt))] if nxt else []),
    ]
    notes = ""
    if agent_files:
        notes += f'<p class="note">The agent record is not walked through. {len(agent_files)} files under {AGENT} are in this diff, and the line counts leave them out.</p>'
    if fresh:
        notes += f'<p class="note">{len(fresh)} untracked files are shown as new files. Track them before you commit.</p>'
    walk = []
    for i, s in enumerate(steps, 1):
        files = s.get("files", [])
        sa, sr = sum(stats[f][0] for f in files), sum(stats[f][1] for f in files)
        alerts = "".join(f'<div class="alert">{badge(fd["severity"], SEV[fd["severity"]])}<span>{md(fd.get("text", ""))}</span></div>' for fd in s.get("findings", []))
        per_file = "".join(
            f'<details class="file"><summary><code>{t(f)}</code>{counts(*stats[f])}</summary>'
            f'<pre class="diff">{diff_html(git(repo, "diff", "--no-renames", base, "--", f))}</pre></details>' for f in files)
        walk.append(
            f'<details class="card step"><summary><span class="num">{i}</span><span class="ttl">{t(s.get("title", ""))}</span>'
            f'<span class="meta">{len(files)} file{"" if len(files) == 1 else "s"}</span>{counts(sa, sr)}</summary>'
            f'<div class="body"><p>{md(s["summary"])}</p><ul>' + "".join(f"<li>{md(c)}</li>" for c in s["changes"]) + f"</ul>{alerts}{per_file}</div></details>")
    body.append(section("walkthrough", "Walkthrough", "".join(walk)) + notes)

    nav = "".join(f'<a href="#{a}">{n}</a>' for a, n in [("summary", "At a glance"), *([("diagrams", "Diagrams")] if diagrams else []), ("verified", "Checks"), ("decisions", "Decisions"), ("open", "Open"), *([("next", "Follow-up")] if nxt else []), ("walkthrough", "Walkthrough")])
    script = f'<script type="module">import mermaid from "{MERMAID}";mermaid.initialize({{theme:matchMedia("(prefers-color-scheme: dark)").matches?"dark":"default"}});</script>' if diagrams else ""
    page = ('<!doctype html><html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width, initial-scale=1">'
            f"<title>{t(d['title'])}</title><style>{CSS}</style></head><body><main>"
            f'<nav>{nav}<button id="tog">Expand all</button></nav>{"".join(body)}</main><script>{SCRIPT}</script>{script}</body></html>')
    open(out, "w").write(page)
    print(f"wrote {out}: {len(names)} files, +{add} -{dele}, {len(fresh)} untracked shown as new, {len(warned)} style warnings")
    os.unlink(idx)


main()
