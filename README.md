# xslint-action

[![License](https://img.shields.io/badge/license-MIT-green)](LICENSE.txt)

GitHub Action for [xslint](https://github.com/maxonfjvipon/xslint) - a CLI
linter for XSL stylesheets. By default it runs with `--format github`, so each
defect appears as an inline annotation on the pull-request diff, with no
SARIF-upload step.

## Usage

Add this action to your workflow:

```yaml
name: xslint
on: [push, pull_request]
jobs:
  xslint:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v6
      - uses: maxonfjvipon/xslint-action@0.0.4
```

With no inputs it lints the whole checkout and annotates the diff.

## Inputs

All inputs are optional:

- `args`: files and directories to check, one per line (defaults to `.`).
- `suppress`: checks to suppress, one per line.
- `format`: output format - `github` (default), `text`, `json`, or `sarif`.
- `max-warnings`: warnings to allow before the run fails (`-1` allows any).
- `config`: path to a `.xslint.yml` configuration file.
- `quiet`: set to `true` to suppress the informational logs.

## Examples

Lint specific paths:

```yaml
- uses: maxonfjvipon/xslint-action@0.0.4
  with:
    args: |
      src/xsl
      resources/hello.xsl
```

Suppress specific checks:

```yaml
- uses: maxonfjvipon/xslint-action@0.0.4
  with:
    suppress: |
      short-names
      confusing-variable-and-node
```

Allow up to ten warnings and emit SARIF instead of annotations:

```yaml
- uses: maxonfjvipon/xslint-action@0.0.4
  with:
    max-warnings: '10'
    format: 'sarif'
```

## How to Contribute

Fork repository, make changes, then send us a [pull request][guidelines].
We will review your changes and apply them to the `master` branch shortly,
provided they don't violate our quality standards. To avoid frustration,
before sending us your pull request please make sure all your tests pass:

```bash
make
```

You will need GNU [make] and [Node.js] installed

## License

Copyright (c) 2026 Max Trunnikov. MIT License.

[guidelines]: https://www.yegor256.com/2014/04/15/github-guidelines.html
[make]: https://www.gnu.org/software/make/manual/make.html
[Node.js]: https://nodejs.org
