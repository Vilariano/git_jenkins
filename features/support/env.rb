require 'capybara'
require 'capybara/dsl'
require 'capybara/rspec/matchers'
require 'selenium-webdriver'
require 'site_prism'
require 'cpf_faker'
require 'faker'
require 'rspec'

require_relative 'helper.rb'
require_relative 'page_helper.rb'

World(Capybara::DSL)
World(Capybara::RSpecMatchers)

World(Page)
World(Helper)

BROWSER = ENV['BROWSER']
AMBIENTE = ENV['AMBIENTE']

CONFIG = YAML.load_file(File.dirname(__FILE__) + "/ambientes/#{AMBIENTE}.yml")

Capybara.register_driver :selenium do |app|
  if BROWSER.eql?('chrome')
    Capybara::Selenium::Driver.new(
      app,
      browser: :chrome,
      desired_capabilities: Selenium::WebDriver::Remote::Capabilities.chrome(
        'chromeOptions' => { 'args' => ['--incognito',
                                        '--disable-cache',
                                        'start-maximized',
                                        '--disable-infobars'] }
      )
    )
  elsif BROWSER.eql?('chrome_headless')
    Capybara::Selenium::Driver.new(
      app,
      browser: :chrome,
      desired_capabilities: Selenium::WebDriver::Remote::Capabilities.chrome(
        'chromeOptions' => { 'args' => ['--start-maximized',
                                        '--headless',
                                        '--disable-gpu',
                                        '--no-sandbox'] }
      )
    )
  elsif BROWSER.eql?('ci_headless')
    Capybara.javascript_driver = :selenium
    Capybara.run_server = false

    caps = Selenium::WebDriver::Remote::Capabilities.chrome(
      'chromeOptions' => {'args' => ['--no-default-browser-check']}
    )

    Capybara.register_driver :selenium_chrome do |app|
      Capybara::Selenium::Driver.new(
        app,
        browser: :remote,
        url: 'http://selenium:4444/wd/hub',
        desired_capabilities: caps
      )
    end  
  elsif BROWSER.eql?('firefox')
    Capybara::Selenium::Driver.new(
      app,
      browser: :firefox,
      marionette: true
    )
  elsif BROWSER.eql?('firefox_headless')
    browser_options = Selenium::WebDriver::Firefox::Options.new(
      args: ['--headless',
             'disable-gpu',
             '--disable-cache']
    )
    Capybara::Selenium::Driver.new(
      app,
      browser: :firefox,
      options: browser_options
    )
  elsif BROWSER.eql?('chrome_mobile')
    Capybara::Selenium::Driver.new(
      app,
      browser: :chrome,
      desired_capabilities: Selenium::WebDriver::Remote::Capabilities.chrome(
        chromeOptions: {
          'mobileEmulation': {
            'deviceName': 'Galaxy S5'
          },
          args: [
            'incognito',
            'disable-extensions',
            'headless',
            'disable-gpu',
            'no-sandbox'
          ]
        },
        loggingPrefs: {
          browser: 'ALL'
        }
      )
    )
  elsif BROWSER.eql?('chrome_mob_headless')
    Capybara::Selenium::Driver.new(
      app,
      browser: :chrome,
      desired_capabilities: Selenium::WebDriver::Remote::Capabilities.chrome(
        chromeOptions: {
          'mobileEmulation': {
            'deviceName': 'Galaxy S5'
          },
          args: [
            '--incognito',
            '--headless',
            '--disable-gpu',
            '--no-sandbox'
          ]
        }
        # loggingPrefs: {
        #   browser: 'ALL'
        # }
      )
    )
  end
end

Capybara.configure do |config|
  config.default_driver = :selenium_chrome #selenium_chrome #selenium_chrome_hendless
  config.default_max_wait_time = 120
  config.app_host = CONFIG['url_padrao']
end
