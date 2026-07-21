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

Use the workflow-based process as the source of truth:

1. Open GitHub Actions and run `Puppeteer upgrade PR`.
2. Set `puppeteer_version` (for example `25.2.1`).
3. Leave `base_branch` as `main` unless you need a different target.
4. The workflow updates `package.json`, `Dockerfile_browser_tools.dockerfile`, `yarn.lock`, and `.circleci/config.yml`, then creates or updates a PR.
5. Review and merge once CI is green.

### Browser tools image publish trigger

The browser-tools image is pushed by `.github/workflows/browser_tools_docker_image.yml` when the upgrade branch is pushed.

If that workflow is still configured with explicit branch names, ensure the generated branch (for example `puppeteer-2521`) is included in the trigger list.

Manual fallback (if the workflow cannot be used):

1. Create a `puppeteer-*` branch.
2. Update `Dockerfile_browser_tools.dockerfile` and `package.json`.
3. Run `yarn install`.
4. Update `.circleci/config.yml` to use the matching `checkclientqualifiesdocker/circleci-image:<branch-name>` tag.

Reference PR example:

- https://github.com/ministryofjustice/laa-check-client-qualifies/pull/1482/files

Image tags:

- https://hub.docker.com/r/checkclientqualifiesdocker/circleci-image/tags
