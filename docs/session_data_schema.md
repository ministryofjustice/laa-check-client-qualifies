# Session Data Schema

This repository now includes a machine-readable schema for the per-assessment `session_data` object used by CCQ:

- `docs/session_data.schema.json`

## What This Schema Represents

- The hash persisted under one assessment key in standalone mode (`session[assessment_id]`)
- The hash persisted in Redis in embedded mode (`resource_id` key)
- Form-derived keys from `Flow::Handler::STEPS`
- Add-another collection item structures (for example `incomes`, `benefits`, `vehicles`)
- Operational keys used during the journey (`feature_flags`, `pending`, `early_result`, `api_response`)

This schema does not define the outer cookie-backed Rails session wrapper.

## Regenerating

Run:

```bash
bundle exec ruby script/generate_session_data_schema.rb
```

The generator introspects form classes and ActiveModel attribute types to keep the schema aligned with current code.
