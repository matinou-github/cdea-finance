# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"
pin "@fortawesome/fontawesome-free", to: "@fortawesome--fontawesome-free.js" # @6.6.0

# From "jquery-rails" gem
pin "jquery" # @3.7.1
pin "jquery_ujs", to: "jquery_ujs.js", preload: true

# From "bootstrap" gem
pin "bootstrap", to: "bootstrap.min.js", preload: true
pin "@popperjs/core", to: "popper.js", preload: true

# Use all.js instead of fontawesome.js
pin "@fortawesome/fontawesome-free", to: "https://ga.jspm.io/npm:@fortawesome/fontawesome-free@6.1.2/js/all.js"

# Custom JS
pin "my_script", to: "my_script.js", preload: true
pin "dashboard", to: "dashboard.js", preload: true
pin "jquery.slimscroll", to: "jquery.slimscroll.js", preload: true
pin "tom_select", to: "tom_select.js", preload: true
#pin "fullcalendar", to: "https://cdn.jsdelivr.net/npm/fullcalendar@5.11.0/main.min.js"

pin "@rails/actioncable", to: "actioncable.esm.js"
pin_all_from "app/javascript/channels", under: "channels"