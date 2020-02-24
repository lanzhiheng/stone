require 'test_helper'

class CategoryTest < ActiveSupport::TestCase
  test "should not save category without key" do
    category = Category.new(name: 'name')
    assert_not category.save
  end

  test "should not save category without name" do
    category = Category.new(key: 'key')
    assert_not category.save
  end

  test "can save post with title and body" do
    category = Category.new(key: 'key', name: 'name')
    assert category.save
  end
end
