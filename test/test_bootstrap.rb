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
    p ht
  end

  def test_tabs
    tab = Bootstrap::Tab.new

    tab.add_tab("#tab1", "first tab")
    tab.add_tab("#tab2", "second tab")
    tab.add_tab("#tab3", "third tab")

    ht = tab.to_ht
    p ht
    # Ht.search(ht, "nav > ")
  end
end