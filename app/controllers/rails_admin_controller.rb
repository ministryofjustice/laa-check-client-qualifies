class RailsAdminController < ActionController::Base
  # We don't control how RailsAdmin loads JS/CSS, and the way
  # it does it violates our CSP. Our response is therefore to
  # disable the CSP for RailsAdmin
  content_security_policy false
end
