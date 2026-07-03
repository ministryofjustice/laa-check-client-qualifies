# Feature flags

## Static flags

Static feature flags are controlled by environment variables.

To add a new static flag:

1. Set `"#{flag_name.upcase}_FEATURE_FLAG"` to `"ENABLED"` in each environment where needed.
2. Add `flag_name` to the list of flags in `app/lib/feature_flags.rb`.
3. Decide if the flag is:
   - `global`: always read from env vars
   - `session`: read from `session_data` for journey consistency

Use in code:

```ruby
FeatureFlags.enabled?(:flag_name, session_data)
```

If `session_data` is not available (for example the start page):

```ruby
FeatureFlags.enabled?(:flag_name, without_session_data: true)
```

## Time-based flags

Time-based flags are defined in `app/lib/feature_flags.rb` with an activation date. They default to disabled and turn on at the configured date.

## Overrides endpoint

If `FEATURE_FLAG_OVERRIDES=enabled`, the `/feature-flags` endpoint can set database-backed overrides for static and time-based flags.
The username is `flags` and the password is stored with the service secrets in Kubernetes.

## Testing guidance

In specs, temporarily override env vars in an `around` block and always restore values after each example to avoid leaking state.
