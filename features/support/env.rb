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

World Capybara::DSL
World Capybara::RSpecMatchers

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
        'chromeOptions' => { 'args' => ['--incognito',
                                        '--headless',
                                        'disable-gpu',
                                        '--disable-cache',
                                        '--disable-infobars'] }
      )
    )
  elsif BROWSER.eql?('ci_headless')
    Capybara::Selenium::Driver.new(app,
      :browser => :remote,
      :desired_capabilities => :chrome,
      :url => "http://selenium-hub:4444/wd/hub"
    )
  end
end

Capybara.configure do |config|
  config.default_driver = :selenium #selenium_chrome #selenium_chrome_hendless
  config.default_max_wait_time = 120
  config.app_host = CONFIG['url_padrao']
end
