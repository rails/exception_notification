require 'test_helper'
require 'exception_notifier_helper'


class PathTest < Test::Unit::TestCase
  include ExceptionNotifierHelper

  EN_ROOT = File.expand_path(File.join(File.dirname(__FILE__), '..'))

  def test_partial_search_paths_include_both_common_extensions
    expected_paths = ["#{EN_ROOT}/views/exception_notifier/_mypartial.html.erb",
     "#{EN_ROOT}/views/exception_notifier/_mypartial.rhtml",
     "./app/views/exception_notifier/_mypartial.html.erb",
     "./app/views/exception_notifier/_mypartial.rhtml"]
    assert_equal(expected_paths.sort, partial_paths("mypartial").sort)
  end 

  def test_partial_paths_actually_finds_plugin_partial
    assert partial_paths('backtrace').detect {|p| File.exist?(p) }
  end

end

