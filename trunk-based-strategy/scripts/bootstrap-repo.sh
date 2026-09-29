#!/usr/bin/env bash
# Apply the trunk-based setup to a repo.
#
#   ./scripts/bootstrap-repo.sh ~/abhiram-git/Docker
#   ./scripts/bootstrap-repo.sh ~/abhiram-git/*/
#
# Copies the hooks, workflow, ruleset and docs into the target repo, points the
# clone at the versioned hooks, and leaves everything uncommitted for review.
# Re-running it overwrites the managed files and nothing else.
set -euo pipefail

src=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)

if [ "$#" -eq 0 ]; then
	echo "usage: $(basename "$0") <repo-path> [repo-path ...]" >&2
	exit 64
fi

for target in "$@"; do
	target=${target%/}
	if [ ! -d "$target/.git" ]; then
		echo "skip  $target (not a git repo)" >&2
		continue
	fi

	mkdir -p "$target/.githooks" \
	         "$target/.github/workflows" \
	         "$target/.github/rulesets" \
	         "$target/scripts"

	# Note the dot: these live hidden at the repo root, but are stored
	# unhidden here so the reference folder stays browsable on GitHub.
	cp "$src/githooks/commit-msg"                   "$target/.githooks/"
	cp "$src/githooks/pre-push"                     "$target/.githooks/"
	cp "$src/github/workflows/commit-lint.yml"      "$target/.github/workflows/"
	cp "$src/github/rulesets/trunk-protection.json" "$target/.github/rulesets/"
	cp "$src/github/pull_request_template.md"       "$target/.github/"
	cp "$src/scripts/install-hooks.sh"              "$target/scripts/"
	cp "$src/scripts/apply-ruleset.sh"              "$target/scripts/"
	cp "$src/CONTRIBUTING.md"                       "$target/"

	chmod +x "$target/.githooks/"* "$target/scripts/"*
	git -C "$target" config core.hooksPath .githooks

	echo "ok    $target ($(git -C "$target" status --porcelain | wc -l) paths changed)"
done

cat <<'EOF'

Next, in each repo:
  git switch -c TRY-<n> && git add -A && git commit -m 'TRY-<n>: ...' && git push -u origin TRY-<n>
  ./scripts/apply-ruleset.sh      # once the workflow exists on the default branch
EOF
