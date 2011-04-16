require File.join(File.dirname(__FILE__), '..', '..', 'test_helper')
require 'digest/sha1'

class Regentanz::Cache::BaseTest < ActiveSupport::TestCase

  LINT_METHODS = [:available?, :expire!, :get, :set, :valid?]

  test "should define public interface for all cache backend" do
    obj = Regentanz::Cache::Base.new
    LINT_METHODS.each do |method|
      assert_respond_to obj, method
    end
  end

  test "should have check cache backend compatability via lint class method" do
    assert_respond_to Regentanz::Cache::Base, :lint

    obj = Object.new
    assert !Regentanz::Cache::Base.lint(obj)
    assert !Regentanz::Cache::Base.lint(Object)

    LINT_METHODS.each do |method|
      Object.any_instance.stubs(method)
    end
    assert Regentanz::Cache::Base.lint(obj)
    assert Regentanz::Cache::Base.lint(Object)
  end

  test "should have key sanitizer class method" do
    assert_respond_to Regentanz::Cache::Base, :sanitize_key
    Time.expects(:now).returns("time data")
    key = Digest::SHA1.hexdigest("--a test string--time data")
    assert_equal key, Regentanz::Cache::Base.sanitize_key("a test string")
  end


end