require 'test_helper'
require 'exception_notifier_helper'


class PathTest < Test::Unit::TestCase
  include ExceptionNotifierHelper

#  RAILS_ROOT = "/devel/myapp"
#  VIEW_PATH = "views/stuff"
#  APP_PATH = "#{RAILS_ROOT}/app/#{VIEW_PATH}"
  THIS_DIR = File.dirname(__FILE__)

  def test_partial_paths
    paths = partial_paths("mypartial")
    assert_equal(expected_paths.sort, paths.sort)
  end 

  def expected_paths
    ["./../lib/../views/exception_notifier/_mypartial.html.erb",
     "./../lib/../views/exception_notifier/_mypartial.rhtml",
     "./app/views/exception_notifier/_mypartial.html.erb",
     "./app/views/exception_notifier/_mypartial.rhtml"]
  end
end

