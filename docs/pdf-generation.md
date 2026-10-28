# PDF generation and Puppeteer

## Saving PDFs

The service uses Grover for PDF generation, which uses Puppeteer.

Because assets are loaded over HTTP from the app itself, local PDF generation requires a multi-threaded app server.

Run with:

```bash
MULTI_THREAD=1 bundle exec rails s
```

## Accessibility notes

PDF rendering has specific accessibility accommodations:

- Some `<h2>` and `<p>` output is represented with list structures for better iOS screenreader focus on mobile and tablet.
- Helper methods in `results_helper.rb` construct PDF-friendly markup and remove styles that reduce screenreader clarity.
- Numeric table cells for PDFs should use the helper method `pdf_friendly_numeric_table_cell`.

## Puppeteer upgrade process

Puppeteer is pinned and occasionally requires upgrades as Chrome changes.

Use the workflow-based process from trusted `main`:

1. Open GitHub Actions and run `Puppeteer upgrade PR`.
2. Set `puppeteer_version` (for example `25.2.1`).
3. An already-current version is a no-op by default. To rebuild its runner, enable `rebuild_runner`. Dependency versions remain unchanged.
4. The workflow prepares from one captured `main` commit. It builds and smoke-tests the tooling-only runner before publishing the upgrade branch. It checks Ruby, Puppeteer, required tools, and a headless Chrome launch as the non-root CI user.
5. Each run publishes a unique image tag containing Ruby and Puppeteer versions, the workflow run ID, and its attempt number. The workflow verifies the digest is retrievable and pins it in `.circleci/config.yml`.
6. A retry reuses an existing automation-owned upgrade branch and open PR. Before updating, the workflow checks that `main`, the branch SHA, and the PR number and head are unchanged. It updates the branch with `--force-with-lease` and edits the same PR. If updating the PR fails, the workflow attempts to restore the previous branch SHA. If `main` advances during the build, start a fresh run.
7. Review and merge once CI is green. A maintainer may need to approve the PR's GitHub Actions checks.

There is no push-triggered runner publisher or mutable `main` image tag. Manually authored PRs must keep the application Puppeteer version, runner Puppeteer version, Ruby version, and CircleCI image digest consistent. Pushing a branch does not build or repair its runner.

Reference PR example:

- https://github.com/ministryofjustice/laa-check-client-qualifies/pull/1482/files

Image tags:

- https://hub.docker.com/r/checkclientqualifiesdocker/circleci-image/tags
