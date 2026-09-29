# Trunk-based branching strategy

The setup that enforces trunk-based development and `TRY-<number>:` commit
messages across the `korothabhiram` repos. It was applied to AWS, Ansible,
Docker, Git, Kubernetes, Portfolio and Terraform in September 2026.

This folder is the reference copy: the source of truth for the files, plus the
reasoning behind them. The live copies sit at the root of each repo.

## The model

`main` is the trunk. It is always releasable, and it is the only long-lived
branch. Work happens on short-lived `TRY-<number>` branches that merge back
within hours or a couple of days, and every change reaches `main` through a
squash-merged pull request.

```
main  ──●────────●────────●────────●──▶   always green, always releasable
         \      /          \      /
          ●────●            ●────●        TRY-1, TRY-2 — hours, not weeks
```

The thing that makes this trunk-based rather than a rename of GitFlow is branch
lifetime. Long-lived branches drift, and merging them back is where the pain
lives. If a change cannot land in a day, land it in vertical slices or behind a
flag, each of which keeps `main` green on its own.

## What enforces what

Three layers, because each one alone has a hole. The hook is instant but
skippable with `--no-verify`; CI cannot be skipped but only runs after a push;
the ruleset is what actually stops a bad merge.

| Rule | Hook | CI | Ruleset |
| --- | :---: | :---: | :---: |
| Commit subject is `TRY-<number>: <description>` | ✅ | ✅ | |
| Branch is named `TRY-<number>` | ⚠️ warn | ✅ | |
| PR title is `TRY-<number>: <description>` | | ✅ | |
| No direct push to `main` | ✅ | | ✅ |
| Linear history, squash-merge only | | | ✅ |
| `commit-lint` passes before merge | | | ✅ |
| `main` cannot be deleted or force-pushed | | | ✅ |

## The commit format

```
TRY-<number>: <description>
```

Any `TRY-<number>` is accepted on any branch — the prefix is not checked against
the branch name, so a commit can be cherry-picked between branches without
rewording. The regex, used identically in the hook and in CI:

```
^TRY-[0-9]+: .+
```

```
✅ TRY-1: add ECS task definition for the api service
✅ TRY-42: fix null deref in the health check
❌ add ECS task definition          no prefix
❌ TRY1: add task                   missing hyphen
❌ try-1: add task                  must be uppercase
❌ TRY-1 add task                   missing colon
❌ TRY-1:                           empty description
```

Exempt, because Git writes them for you: `Merge …` and `Revert "…"`.
`fixup!` / `squash!` / `amend!` pass the hook so autosquash keeps working, but
CI fails them — they must be squashed away before the PR merges.

Subjects over 72 characters warn but pass. Put the detail in the body.

## The files

| File | What it does |
| --- | --- |
| `githooks/commit-msg` | Validates the subject at commit time. Installed to `.githooks/` at the repo root. |
| `githooks/pre-push` | Refuses a push whose target ref is `refs/heads/main`. |
| `github/workflows/commit-lint.yml` | PR check. Validates branch name, PR title, and every commit subject in the PR range. |
| `github/rulesets/trunk-protection.json` | Branch protection as code, applied through the GitHub API. |
| `github/repo-settings.json` | Delete the branch once a pull request merges, and allow auto-merge. |
| `github/pull_request_template.md` | Pre-fills the PR body and prompts for the ticket. |
| `scripts/install-hooks.sh` | Sets `core.hooksPath=.githooks` in a clone. Run once per clone. |
| `scripts/apply-ruleset.sh` | Creates or updates the ruleset via `gh api`. |
| `scripts/bootstrap-repo.sh` | Applies all of the above to a repo. |

Hooks live in `.githooks/` rather than `.git/hooks/` because `.git/hooks` is not
versioned and does not survive a fresh clone. `core.hooksPath` redirects Git to
the tracked directory, which is why every clone has to run `install-hooks.sh`
once — that one step cannot itself be automated by the repo.

Inside this reference folder the directories are `githooks/` and `github/`
without the leading dot, so the folder stays browsable on GitHub.
`bootstrap-repo.sh` adds the dots when it copies them into place.

## How it was set up

### 1. Files into every repo

```bash
./scripts/bootstrap-repo.sh ~/abhiram-git/*/
```

This copies the managed files in, sets `core.hooksPath`, and leaves everything
uncommitted. Re-running it overwrites the managed files and touches nothing else.

### 2. Landed through the flow it creates

Each repo got the change on a `TRY-1` branch, pushed, and squash-merged through
a PR — the setup arrives by the rules it establishes, not around them.

```bash
git switch -c TRY-1
git add -A
git commit -m 'TRY-1: add trunk-based workflow and commit-message rules'
git push -u origin TRY-1
gh pr create --fill
```

### 3. `gh` installed without sudo

`apt` carried 2.46 and needed a password, so the current release went into
`~/.local/bin`, which is already on `PATH`:

```bash
V=$(curl -sSL https://api.github.com/repos/cli/cli/releases/latest | jq -r .tag_name | tr -d v)
curl -sSL "https://github.com/cli/cli/releases/download/v${V}/gh_${V}_linux_amd64.tar.gz" | tar -xz
install -m 755 "gh_${V}_linux_amd64/bin/gh" ~/.local/bin/gh
gh auth login
```

### 4. Ruleset applied

Only after the workflow is on `main` — a required status check that has never
run will block every PR.

```bash
./scripts/apply-ruleset.sh
```

## Rulesets vs. repo settings

These are two different things on two different API endpoints, and the
distinction is the one that trips people up:

- A **ruleset** governs what may *reach* a branch — pull request required,
  checks passing, history linear. `POST /repos/{slug}/rulesets`.
- A **repo setting** governs how the repo *behaves* — which merge buttons
  exist, and whether the head branch is deleted afterwards.
  `PATCH /repos/{slug}`.

Automatic branch deletion is the second kind, so it cannot be expressed as a
rule in `trunk-protection.json` no matter how natural that would feel. Both are
stored as JSON here and both are applied by `apply-ruleset.sh`.

Neither one applies itself when the JSON is merged. The file is the source of
truth; the script is what reconciles it with the live service. Merging a change
to either file and expecting GitHub to notice is the most common way to end up
staring at an empty Rulesets page.

`repo-settings.json` deliberately does not set `allow_merge_commit` or
`allow_rebase_merge`. Turning them off looks tidy -- the merge dropdown would
only offer the squash button the ruleset permits -- but it adds no enforcement,
because `allowed_merge_methods` in the ruleset is what actually rejects a
non-squash merge. It also has a side effect worth avoiding: those same flags
gate the **Update branch** dropdown, which is a different button. That one
syncs your branch *from* main when it has fallen behind, offering "Update with
merge commit" and "Update with rebase". Disabling both repo flags can leave it
with neither option, and `strict_required_status_checks_policy` means you need
that button on every branch that falls behind. Enforcement belongs in the
ruleset; the repo flags only shape the UI, including parts of it you still
want.

Deletion applies to the branch on GitHub; your local copy survives, so prune it:

```bash
git switch main && git pull --prune
git branch -d TRY-1
```

## Notes on the ruleset

`required_approving_review_count` is `0`. GitHub will not let you approve your
own pull request, so on a solo repo any higher number deadlocks it: the PR can
never collect the approval it requires. The PR gate, the status check and the
linear-history rule still apply; the review count is the one rule that cannot.

`bypass_actors` is empty, so the ruleset binds repo admins too. That is
deliberate — a bypass that is always available is not a rule. To add an
emergency escape hatch, put your actor entry in `bypass_actors` and re-apply.

`strict_required_status_checks_policy` requires the branch to be up to date with
`main` before merging, which is what stops two individually-green PRs from
landing a broken `main` between them.

## Common tasks

```bash
# Fix a rejected message
git commit --amend                    # most recent
git rebase -i <base-sha>              # older: reword each one
git push --force-with-lease

# Start a clone
./scripts/install-hooks.sh

# Emergency bypass, local only — CI and the ruleset still apply
git commit --no-verify
git push --no-verify
```
