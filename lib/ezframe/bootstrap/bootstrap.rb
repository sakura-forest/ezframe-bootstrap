module Ezframe
  module Bootstrap
    class Nav
      def initialize(opts = {})
        @option = opts
        @item_a = []
        init_var
      end

      def init_var
        @option[:wrap_tag] ||= "ul.nav"
        @option[:item_tag] ||= "li.nav-item"
      end

      def add_item(item, opts = {})
        wrapper_ht = Ht.from_array(@option[:item_tag] || opts[:item_tag]) || { tag: :div }
        item_ht = Ht.from_array(item)
        # puts "item=#{item}"
        Ht.connect_child(wrapper_ht, item_ht)
        Ht.add_class(wrapper_ht, opts[:extra_item_class] || @option[:extra_item_class])
        @item_a.push(wrapper_ht)
        return wrapper_ht
      end

      def add_link(link, opts = {})
        link_ht = Ht.from_array(link)
        Ht.add_class(link_ht, "nav-link")
        Ht.add_class(link_ht, opts[:extra_link_class] || @option[:extra_link_class])
        add_item(link_ht, opts)
        return link_ht
      end

      def to_ht
        wrapper_ht = Ht.from_array(@option[:wrap_tag])
        Ht.connect_child(wrapper_ht, @item_a)
        Ht.add_class(wrapper_ht, @option[:extra_wrap_class])
        return wrapper_ht
      end
    end

    class Navbar < Nav
      def init_var
        super
        @option[:wrap_tag] ||= "ul.nav.nav-bar"
      end
    end

    class Sidebar < Nav
      def init_var
        super
        @option[:wrap_tag] = ".sidebar.sidebar-mini > ul.nav.nav-sidebar.flex-column:data-widget=[treeview]:role=[menu]"
        @option[:item_tag] = nil
      end
    end

    class Tab < Nav
      def init_var
        super
        @option[:wrap_tag] = "ul.nav.nav-tabs:role=tablist"
      end

      def add_link(link, opts = {})
        link_ht = super(link, opts)
        link_ht[:role] = "tab"
        link_ht[:"data-toggle"] = "tab"
        return link_ht
      end

      def add_tab(href, tab_name)
        ht = add_link("a:href=[#{href}]:#{tab_name}")
        puts "a:href=[#{href}]:#{tab_name}:ht=#{ht}"
        return ht
      end
    end

    class TabContent < Ht::List
      def init_var
        super
        @option[:wrap_tag] = ".tab-content"
        @option[:item_tag] = ".tab-pane"
      end
    end

    class Treeview < Ht::List
      def init_var
        @option[:wrap_tag] = "ul.nav.nav-treeview"
        @option[:item_tag] = "li.nav-item"
      end
    end

    class Dropdown < Ht::List
      def init_var
        @option[:wrap_tag] = ".dropdown"
      end

      def add_item(item, opts = {})
        ht = Ht.from_array(item)
        Ht.add_class(ht, @option[:extra_item_class] || opts[:extra_item_class])
        @item_a.push(ht)
        return ht
      end

      def to_ht
        wrapper_ht = Ht.from_array(@option[:wrap_tag])
        Ht.connect_child(wrapper_ht, @item_a)
        Ht.add_class(wrapper_ht, @option[:extra_wrap_class])
        return wrapper_ht
      end
    end

    class Form
      attr_accessor :action, :method, :append, :prepend

      def initialize(opts = {})
        @option = opts
        @form_group_a = []
      end

      def add_input(input, opts = {})
        case input[:tag]
        when :input, :textarea, :select
          Ht.add_class(input, "form-control")
          klass = %w[input-group]
        when :checkbox, :radio
          Ht.add_class(input, "form-check-input")
          klass = %w[input-check]
          label_class = "form-check-label"
        end
        opts[:class] = klass
        inpgrp = InputGroup.new(opts)
        inpgrp.add_item(input)
        label = opts[:label]
        if label
          label_ht = Ht.label(label)
          label_ht = Ht.add_class(label_ht, label_class) if label_class
          inpgrp.add_item(label_ht)
        end
        @form_group_a.push(inpgrp)
        return inpgrp
      end

      def add_input_group(opts)
        inpgrp = InputGroup.new(opts)
        opts[:class] ||= %w[input-group]
        @form_group_a.push(inpgrp)
        return inpgrp
      end

      def to_ht
        form = Ht.form(class: %w[form-inline])
        form[:action] = @action
        form[:method] = @method || "POST"
        Ht.add_class(form, @option[:extra_wrap_class])
        children = @form_group_a.map do |grp|
          if grp.respond_to?(:to_ht)
            grp.to_ht
          else
            grp
          end
        end
        children.unshift(@prepend) if @prepend
        children.push(@append) if @append
        form[:child] = children
        return form
      end

      class InputGroup
        attr_accessor :option, :label_class

        def initialize(opts = {})
          @option = opts
          @input_a = []
          return self
        end

        def add_item(item, opts = {})
          ht = Ht.from_array(item)
          @input_a.push(ht)
        end

        def add_prepend(item, opts = {}) 
          ht = Ht.from_array(item)
          @prepend ||= []
          @prepend.push(ht)
          return @prepend
        end

        def add_append(item, opts = {})
          ht = Ht.from_array(item)
          @append ||= []
          @append.push(ht)
          return @append
        end

        def to_ht
          if @prepend
            @input_a.unshift(Ht.div(class: "input-group-prepend", child: @prepend))
          end
          if @append
            @input_a.push(Ht.div(class: "input-group-append", child: @append))
          end
          @option[:class] ||= "input-group"
          klass = [@option[:class], @option[:extra_input_group_class]].compact.flatten
          ht = Ht.div(class: klass)
          ht[:child] = @input_a
          return ht
        end
      end
    end

    class Breadcrumb < Ht::List
      def initialize(opts = {})
        super(opts)
        @option[:wrap_tag] ||= "ol.breadcrumb"
        @option[:item_tag] ||= "li.breadcrumb-item"
      end
    end

    class Card < Ht::List
      attr_accessor :title, :header

      def initialize(opts = {})
        super(opts)
        @option[:wrap_tag] = ".card > .card-body"
        @option[:item_tag] = "p.card-text"
      end

      def add_link(link)
        @link_a ||= []
        @link_a.push(link)
      end

      def to_ht
        stash = { at_first: @at_first.clone, at_last: @at_last.clone }
        @at_first.push(Ht.from_array("h5.card-title:#{@title}")) if @title
        if @link_a
          links = @link_a.map do |lk|
            h = Ht.from_array(lk)
            Ht.add_class(h, "card-link")
            h
          end
          @at_last = links
        end
        ht = super
        @at_first, @at_last = stash[:at_first], stash[:at_last]
        if @header
          card = Ht.search(ht, ".card")
          card[:child] = [Ht.from_array([".card-header", [@header]]), card[:child]]
        end
        return ht
      end
    end
  end
end
