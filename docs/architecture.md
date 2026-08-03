# Architecture notes

## Data access hierarchy

User-entered values are stored in session data and accessed through domain objects:

1. `Steps::Logic`
   - Reads specific session attributes that affect journey branching.
2. `Steps::Helper`
   - Determines which steps are relevant for a check.
3. `Flow::Handler`
   - Maps each step to the corresponding form object.
4. `Check`
   - Provides relevant data only; returns `nil` for attributes that are not relevant given prior answers.

## Flow logic and sections

Steps are defined in `app/lib/steps` and grouped into sections shown on the check-answers page:

- `NonFinancialSection`
- `IncomeSection`
- `PartnerSection`
- `OutgoingsSection`
- `PropertySection`
- `AssetsAndVehiclesSection`

Steps are also grouped for change-answer behavior. When changing an answer, CCQ replays from the selected step through subsequent steps in that group.

## I18n

Most user-facing copy is in `config/locales/en.yml`.

To check for likely unused keys during test runs:

```bash
CHECK_UNUSED_KEYS=true bundle exec rspec
```

## Analytics allow-lists

Analytics event fields `event_type` and `page` are validated against allow-lists.

When adding new pages, update:

- `config/allowed_analytics_pages.yml`

When adding new external links via `app/services/external_link_service.rb`, update:

- `config/allowed_analytics_event_types.yml`

Missing entries can trigger Sentry errors.
