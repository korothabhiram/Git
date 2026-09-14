# 🔀 Git

## 📘 What is Git?

Git is a **distributed version control system** designed to handle everything from small to very large projects with speed and efficiency. It helps you track code changes, collaborate with other developers, and manage different versions of your codebase—with every clone holding the full history, not just a snapshot.

---

## 🙋‍♂️ Who Should Use Git?

- **Developers**: Track changes and collaborate without overwriting each other's work.
- **DevOps Engineers**: Drive CI/CD pipelines off branches, tags, and commits.
- **Teams**: Review code via pull/merge requests and enforce history standards.
- **Open Source Contributors**: Fork, branch, and submit changes upstream.
- **Tech Learners**: Build the habit of versioning everything, not just code.

---

## 🎯 Why Use Git?

- 🌳 Cheap, fast branching and merging
- 🌐 Fully distributed—every clone is a complete backup
- 🔁 Full history, diffing, and blame for every file
- 🤝 Powers collaboration workflows (PRs, code review, CI/CD)
- ⚡ Fast, even on huge codebases

---
# 🔀 Top Git Commands Cheat Sheet

A handy, stylish list of the **most useful Git commands** you'll use for commits, branches, remotes, and history. Perfect for beginners and pros alike!

---

## ⚙️ Setup & Config

| Command | Description |
|--------|-------------|
| `git init` | 🆕 Initialize a new repository |
| `git clone <url>` | 📥 Clone a remote repository |
| `git config --global user.name "<name>"` | 🏷️ Set your global username |
| `git config --global user.email "<email>"` | 📧 Set your global email |
| `git config --list` | 📋 List all config settings |
| `git config user.name` | 🔍 Show config value for current repo |

---

## 📦 Basic Snapshotting

| Command | Description |
|--------|-------------|
| `git status` | 👀 Show working tree status |
| `git add <file>` | ➕ Stage a file |
| `git add .` | ➕ Stage all changes in current directory |
| `git add -p` | 🔍 Interactively stage hunks of a file |
| `git commit -m "<msg>"` | ✅ Commit staged changes |
| `git commit --amend` | ✏️ Modify the last commit |
| `git commit -a -m "<msg>"` | ⚡ Stage tracked files and commit in one step |
| `git rm <file>` | 🗑️ Remove a file and stage the removal |
| `git mv <old> <new>` | 🚚 Move/rename a file |

---

## 🔍 Inspecting History

| Command | Description |
|--------|-------------|
| `git log` | 📜 Show commit history |
| `git log --oneline` | 📄 Compact one-line-per-commit log |
| `git log --graph --oneline --all` | 🌳 Visual branch/commit graph |
| `git log -p <file>` | 🔍 Show commit history with diffs for a file |
| `git show <commit>` | 🔎 Show details of a specific commit |
| `git diff` | 🆚 Show unstaged changes |
| `git diff --staged` | 🆚 Show staged changes vs last commit |
| `git blame <file>` | 🕵️ Show who last changed each line |

---

## 🌿 Branching

| Command | Description |
|--------|-------------|
| `git branch` | 📋 List local branches |
| `git branch -a` | 🌍 List all branches (local + remote) |
| `git branch <name>` | 🆕 Create a new branch |
| `git branch -d <name>` | 🗑️ Delete a branch (safe) |
| `git branch -D <name>` | 💣 Force delete a branch |
| `git checkout <branch>` | 🔀 Switch to a branch |
| `git checkout -b <branch>` | 🆕 Create and switch to a new branch |
| `git switch <branch>` | 🔀 Switch to a branch (modern syntax) |
| `git switch -c <branch>` | 🆕 Create and switch (modern syntax) |

---

## 🔗 Merging & Rebasing

| Command | Description |
|--------|-------------|
| `git merge <branch>` | 🔀 Merge a branch into the current one |
| `git merge --no-ff <branch>` | 🔀 Merge while preserving a merge commit |
| `git rebase <branch>` | 🔁 Reapply commits on top of another base |
| `git rebase -i HEAD~<n>` | 🎛️ Interactive rebase—squash/edit/reorder commits |
| `git rebase --continue` | ▶️ Continue rebase after resolving conflicts |
| `git rebase --abort` | ⏹️ Cancel an in-progress rebase |
| `git cherry-pick <commit>` | 🍒 Apply a specific commit onto current branch |

---

## 🌐 Remotes

| Command | Description |
|--------|-------------|
| `git remote -v` | 📋 List remotes and their URLs |
| `git remote add <name> <url>` | ➕ Add a new remote |
| `git remote remove <name>` | 🗑️ Remove a remote |
| `git fetch <remote>` | 📥 Download objects/refs without merging |
| `git pull` | ⬇️ Fetch and merge from remote |
| `git pull --rebase` | ⬇️ Fetch and rebase instead of merge |
| `git push` | ⬆️ Push commits to remote |
| `git push -u origin <branch>` | ⬆️ Push and set upstream tracking branch |
| `git push --force-with-lease` | ⚠️ Safer force push (checks remote hasn't changed) |

---

## 💾 Stashing

| Command | Description |
|--------|-------------|
| `git stash` | 📦 Stash uncommitted changes |
| `git stash -u` | 📦 Stash including untracked files |
| `git stash list` | 📋 List all stashes |
| `git stash pop` | ⬆️ Reapply and remove the latest stash |
| `git stash apply` | ⬆️ Reapply latest stash without removing it |
| `git stash drop` | 🗑️ Delete a stash |

---

## ↩️ Undoing Changes

| Command | Description |
|--------|-------------|
| `git restore <file>` | ⏪ Discard unstaged changes to a file |
| `git restore --staged <file>` | ⏪ Unstage a file (keep changes) |
| `git checkout -- <file>` | ⏪ Discard unstaged changes (legacy syntax) |
| `git reset <file>` | ⏪ Unstage a file |
| `git reset --soft HEAD~1` | ↩️ Undo last commit, keep changes staged |
| `git reset --mixed HEAD~1` | ↩️ Undo last commit, keep changes unstaged |
| `git reset --hard HEAD~1` | 💣 Undo last commit, discard all changes |
| `git revert <commit>` | 🔄 Create a new commit that undoes a commit |
| `git clean -fd` | 🧹 Remove untracked files and directories |

---

## 🏷️ Tags

| Command | Description |
|--------|-------------|
| `git tag` | 📋 List tags |
| `git tag <name>` | 🏷️ Create a lightweight tag |
| `git tag -a <name> -m "<msg>"` | 🏷️ Create an annotated tag |
| `git push origin <tag>` | ⬆️ Push a single tag |
| `git push origin --tags` | ⬆️ Push all tags |
| `git tag -d <name>` | 🗑️ Delete a local tag |

---

## 🧩 Submodules

| Command | Description |
|--------|-------------|
| `git submodule add <url> <path>` | ➕ Add a submodule |
| `git submodule init` | ⚙️ Initialize submodules |
| `git submodule update` | 🔄 Fetch submodule commits |
| `git submodule update --init --recursive` | 🔄 Init and update all submodules recursively |

---

## 🔍 Searching & Debugging

| Command | Description |
|--------|-------------|
| `git grep "<pattern>"` | 🔍 Search tracked files for a pattern |
| `git bisect start` | 🐛 Begin binary search for a bad commit |
| `git bisect bad` / `git bisect good` | 🐛 Mark current commit during bisect |
| `git reflog` | 🕰️ Show history of HEAD movements (recover "lost" commits) |
| `git fsck` | 🩺 Check repository integrity |

---

## 🧠 Tip

💡 Use `--help` with any Git command to learn more, e.g.:

```bash
git log --help
```

---

> ✅ Keep this README as a reference for your Git journey. Contributions welcome!
> ⭐ Star this repo if you found it helpful!
