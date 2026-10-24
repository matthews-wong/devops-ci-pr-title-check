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
