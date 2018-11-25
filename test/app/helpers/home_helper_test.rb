require File.expand_path(File.dirname(__FILE__) + '/../../test_config.rb')

class HomeHelperTest < Test::Unit::TestCase
  def self.setup
    @helpers = Class.new
    @helpers.extend Firewah::App::HomeHelper
  end

  def helpers
    @helpers
  end

  def test_foo_helper
    assert_equal nil, helpers.foo
  end
end
