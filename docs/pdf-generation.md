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

- Some `<h2>` and `<p>` output is represented with list structures for better iOS screenreader focus.
- Numeric table cells for PDFs should use the helper method `pdf_friendly_numeric_table_cell`.

## Manual Puppeteer upgrade process

Puppeteer is pinned and occasionally requires manual upgrades as Chrome changes.

Typical steps:

1. Create a branch named for the Puppeteer upgrade (for example `puppeteer-24xx`).
2. Update `Dockerfile_browser_tools.dockerfile` and `package.json`.
3. Run `yarn install` to update `yarn.lock`.
4. Add the branch name in `.github/workflows/browser_tools_docker_image.yml` to publish the image.
5. Update `.circleci/config.yml` to reference the new browser-tools image.

Reference PR example:

- https://github.com/ministryofjustice/laa-check-client-qualifies/pull/1482/files

Image tags:

- https://hub.docker.com/r/checkclientqualifiesdocker/circleci-image/tags
