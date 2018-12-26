require File.expand_path(File.dirname(__FILE__) + '/../../test_config.rb')

class HomeControllerTest < Test::Unit::TestCase
  def setup
    $REDIS = mock('redis conn')
  end

  def test_returns_hello_world_text
    get "/"
    assert_equal true, last_response.body.include?('Firewah')
  end
end
