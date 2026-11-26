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

Puppeteer is pinned in `package.json`. Dependabot proposes updates under the npm policy in `.github/dependabot.yml`.

- Minor and patch updates join the `combined-dependencies` group.
- Major updates open their own PR for separate review.
- Review and merge once CircleCI is green.

No custom browser image is needed. CircleCI runs on the stock `cimg/ruby:<version>-browsers` image. The standalone specs install Chrome with the application's Puppeteer CLI before they run, so Chrome matches the Puppeteer version in `package.json`.

## Ruby upgrade process

Dependabot does not update Ruby. Use the standalone helper with the target Ruby version installed:

```bash
ruby script/update_ruby_version.rb <version>
bundle lock
```

Use a complete version such as `4.0.9`. The helper must run under that Ruby version. It updates `.ruby-version`, `Gemfile`, `Dockerfile`, `docker-images.json`, and `.circleci/config.yml`. It checks that both `ruby:<version>-slim-bookworm` and `cimg/ruby:<version>-browsers` exist upstream. Missing images stop it before any file changes. `bundle lock` refreshes the Ruby metadata in `Gemfile.lock`.
