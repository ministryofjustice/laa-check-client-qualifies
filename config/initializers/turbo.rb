# Fix for bug where as of Rails 7.1.2 Turbo fails if ActionCable is not installed.
# See https://github.com/hotwired/turbo-rails/issues/512
Rails.autoloaders.once.do_not_eager_load("#{Turbo::Engine.root}/app/channels")
