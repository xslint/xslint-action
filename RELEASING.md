# Releasing

`xslint-action` releases **automatically** whenever `xslint` releases, and
can also be released by hand.

## Automatic (the cascade)

When `xslint` publishes a new version it dispatches `xslint-released` here.
[`.github/workflows/cascade.yml`](.github/workflows/cascade.yml) bumps the
pinned `@maxonfjvipon/xslint` in `index.js` to that version, validates with
`make all`, and cuts this action's own next patch — its latest tag + 1,
independent of xslint's number — pushing the tag so `release.yml` cuts the
GitHub release. Nothing to do; it happens.

## Manual

Commit any changes, then push a semver tag:

```bash
git tag 0.0.7
git push origin 0.0.7
```

The tag triggers [`release.yml`](.github/workflows/release.yml), which creates
the GitHub release with generated notes. Consumers pin an exact version
(`uses: xslint/xslint-action@0.0.7`); there is no moving major tag.

## Prerequisites

- `DISPATCH_TOKEN` — an organization secret (PAT, `repo` + `workflow` scope).
- The `master` ruleset grants the organization admin a bypass, so the
  cascade's bump can push to the protected branch.
