require File.expand_path(File.dirname(__FILE__) + '/../../test_config.rb')

class FwTest < Test::Unit::TestCase

  def test_parse_rules
    f = File.read(File.dirname(__FILE__) + '/assets/fw.output')

    rules = Fw.parse_fw(f)

    assert_equal 4, rules.size

  end
end
