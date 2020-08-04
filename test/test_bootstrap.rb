require "ezframe"
require "ezframe/bootstrap"
require 'minitest/autorun'

ENV["RACK_ENV"] = "test"

class TestBootstrap < MiniTest::Test
  include Ezframe

  def test_navbar
    navbar = Bootstrap::Navbar.new
    navbar.add_item("a:nav-link:href=[http://www.asahi.com]:asahi.com")
    navbar.add_item("a:nav-link:href=[http://www.google.com]:Google")
    ht = navbar.to_ht
    puts "navbar: #{ht}"
  end

  def test_tabs
    tab = Bootstrap::Tab.new

    tab.add_tab("#tab1", "first tab")
    tab.add_tab("#tab2", "second tab")
    tab.add_tab("#tab3", "third tab")

    ht = tab.to_ht
    p "tabs: #{ht}"
    assert_equal(:ul, ht[:tag])
    child = ht[:child]
    assert_equal(Array, child.class)
    assert_equal(3, child.length)
  end

  def test_dropdown
    menu = Bootstrap::Dropdown.new
    menu.add_item("a:href=[#1]:link1")
    menu.add_item("a:href=[#2]:link2")
    menu.add_item("a:href=[#3]:link2")
    ht = menu.to_ht
    puts "dropdown: #{ht}"
  end
end