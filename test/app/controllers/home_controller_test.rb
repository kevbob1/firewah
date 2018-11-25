require File.expand_path(File.dirname(__FILE__) + '/../../test_config.rb')

class HomeControllerTest < Test::Unit::TestCase
  def setup
    get "/"
  end

  def test_returns_hello_world_text
    assert_equal "Hello World", last_response.body
  end
end
