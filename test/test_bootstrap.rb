require "ezframe"
require "ezframe/bootstrap"
require 'minitest/autorun'

ENV["RACK_ENV"] = "test"

class TestBootstrap < MiniTest::Test
  include Ezframe

  def test_navbar
    navbar = Bootstrap::Navbar.new
    navbar.add_item("a.nav-link:href=[http://www.asahi.com]:asahi.com")
    navbar.add_item("a.nav-link:href=[http://www.google.com]:Google")
    ht = navbar.to_ht
    puts "navbar: #{ht}"
    assert_equal(:ul, ht[:tag])
    child = ht[:child]
    assert_equal(Array, child.class)
    assert_equal(2, child.length)
    ch1 = child[0]
    assert_equal(:li, ch1[:tag])
    assert_equal(%w[nav-item], ch1[:class])
    link1 = ch1[:child]
    assert_equal(:a, link1[:tag])
    assert_equal(%w[nav-link], link1[:class])
  end

  def test_tabs
    tab = Bootstrap::Tab.new

    tab.add_tab("#tab1", "first tab")
    tab.add_tab("#tab2", "second tab")
    tab.add_tab("#tab3", "third tab")

    ht = tab.to_ht
    puts "tabs: #{ht}"
    assert_equal(:ul, ht[:tag])
    child = ht[:child]
    assert_equal(Array, child.class)
    assert_equal(3, child.length)
  end

  def test_tab_content
    cont = Bootstrap::TabContent.new
    cont.add_item("#tab1")
    cont.add_item("#tab2")
    cont.add_item("#tab3")
    ht = cont.to_ht
    puts "tab_content: #{ht}"
    assert_equal(:div, ht[:tag])
    child = ht[:child]
    assert_equal(Array, child.class)
    assert_equal(3, child.length)
    tab1 = child[0]
    assert_equal(:div, tab1[:tag])
    assert_equal(["tab-pane"], tab1[:class])
    cont1 = tab1[:child]
    assert_equal(:div, cont1[:tag])
    assert_equal(:tab1, cont1[:id])
  end

  def test_dropdown
    menu = Bootstrap::Dropdown.new
    menu.add_item("a:href=[#1]:link1")
    menu.add_item("a:href=[#2]:link2")
    menu.add_item("a:href=[#3]:link2")
    ht = menu.to_ht
    puts "dropdown: #{ht}"
    assert(%w[dropdown], ht[:class])
    child = ht[:child]
    assert_equal(Array, child.class)
    assert_equal(3, child.length)
  end
end