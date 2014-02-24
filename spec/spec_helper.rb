ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'
require 'capybara/rspec'

Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

ActiveRecord::Migration.check_pending! if defined?(ActiveRecord::Migration)

RSpec.configure do |config|

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = false
  config.infer_base_class_for_anonymous_controllers = false
  config.order = "random"
  config.include Capybara::DSL

  Paperclip::Attachment.default_options[:path] = ":rails_root/public/system/:rails_env/:class/:attachment/:id_partition/:filename"
  config.after(:all) do
    FileUtils.rm_rf(Dir["#{Rails.root}/public/system/#{Rails.env}"])
  end

end

OmniAuth.config.test_mode = true
omniauth_hash =
    {provider: :facebook,
     uid:      "1234",
     info:   {first_name: "Albert", last_name: "Einstein", email: "aeinstein@email.com"},
     credentials: {token: "testtoken234tsdf"}}
OmniAuth.config.add_mock(:facebook, omniauth_hash)