Capybara.register_driver :chrome do |app|
  Capybara::Selenium::Driver.new(app, browser: :chrome)
end
Capybara.register_driver :headless_chrome do |app|
  capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(chromeOptions: {args: %w(headless)})
  Capybara::Selenium::Driver.new(app, browser: :chrome, desired_capabilities: capabilities)
end
Capybara.javascript_driver = :headless_chrome
Capybara.default_driver = :headless_chrome
Capybara.raise_server_errors = false
