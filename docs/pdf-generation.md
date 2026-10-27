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
3. The workflow updates `package.json`, `yarn.lock`, and the runner's Puppeteer installation together.
4. An already-current target is a no-op. No image, branch, or PR is created.
5. For a changed target, the workflow builds and smoke-tests the tooling-only runner before publishing the branch. It checks Ruby, Puppeteer, required tools, and a headless Chrome launch as the non-root CI user.
6. The published image tag includes Ruby and Puppeteer versions, the workflow run ID, and its attempt number. The workflow verifies its digest is retrievable and pins that digest in `.circleci/config.yml` before publishing one PR.
7. Review and merge once CI is green. A maintainer may need to approve the PR's GitHub Actions checks.

The workflow starts from one `main` commit and checks that `main` has not changed before publishing the branch. If it has changed, start a fresh run from `main`. Existing upgrade branches are refused rather than replaced. Failed builds, smoke checks, or publication do not publish an upgrade branch.

There is no push-triggered runner publisher or mutable `main` image tag. Manually authored PRs must keep the application Puppeteer version, runner Puppeteer version, Ruby version, and CircleCI image digest consistent. Pushing a branch does not build or repair its runner.

Reference PR example:

- https://github.com/ministryofjustice/laa-check-client-qualifies/pull/1482/files

Image tags:

- https://hub.docker.com/r/checkclientqualifiesdocker/circleci-image/tags
