# devops-ci-pr-title-check

A GitHub Actions workflow that rejects pull requests whose title is not a
[Conventional Commit](https://www.conventionalcommits.org/) subject.

The check is a single bash script, so it runs the same way locally and in CI
and needs no third-party action.

## Rules

A title must look like `type(scope)!: subject`:

- `type` is one of `feat fix perf refactor test docs chore ci style revert`
- `(scope)` is optional, `!` marks a breaking change
- the subject is lower case, imperative, has no trailing period and keeps
  the whole title within 72 characters

## Usage

```sh
scripts/check-pr-title.sh "feat(api): add retry budget"
```

Exit status is 0 for a valid title and 1 otherwise, with the reason on stderr.

## Workflow

`.github/workflows/pr-title.yml` runs on `opened`, `edited`, `synchronize` and
`reopened`, so renaming a PR re-runs the check. The title reaches the script
through an environment variable instead of being expanded into the shell
command, because a PR title is attacker-controlled input.

To block merging on a bad title, mark the `check` job as a required status
check in the branch protection settings.

## Validation

```sh
make validate   # actionlint + shellcheck, then the title tests
```

`actionlint` and `shellcheck` must be on `PATH`; `scripts/install-actionlint.sh`
installs a pinned, checksum-verified actionlint for Linux amd64.
