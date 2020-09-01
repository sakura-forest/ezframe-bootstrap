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
        wrapper_ht = Ht.compact(@option[:item_tag] || opts[:item_tag]) || Ht.div()
        item_ht = Ht.compact(item)
        # puts "item=#{item}"
        Ht.connect_child(wrapper_ht, item_ht)
        Ht.add_class(wrapper_ht, opts[:extra_item_class] || @option[:extra_item_class])
        self.add_raw(wrapper_ht)
        return wrapper_ht
      end

      def add_raw(item)
        @item_a.push(item)
      end

      def add_link(link, opts = {})
        link_ht = Ht.compact(link)
        Ht.add_class(link_ht, "nav-link")
        Ht.add_class(link_ht, opts[:extra_link_class] || @option[:extra_link_class])
        add_item(link_ht, opts)
        return link_ht
      end

      def to_ht
        wrapper_ht = Ht.compact(@option[:wrap_tag])
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
        @option[:wrap_tag] = Ht.compact(".sidebar.sidebar-mini > ul.nav.nav-sidebar.flex-column:data-widget=[treeview]:role=[menu]")
        @option[:item_tag] = nil
      end
    end

    class Tab < Nav
      def init_var
        super
        @option[:wrap_tag] = Ht.compact("ul.nav.nav-tabs:role=tablist")
      end

      def add_link(link, opts = {})
        link_ht = super(link, opts)
        link_ht[:role] = "tab"
        link_ht[:"data-toggle"] = "tab"
        return link_ht
      end

      def add_tab(href, tab_name, opts = {})
        ht = add_link(Ht.compact("a:href=[#{href}]:#{tab_name}"))
        Ht.add_class(ht, opts[:add_class])
        #opts.delete(:add_class)
        # ht.update(opts)
        return ht
      end
    end

    class TabContent < Ht::List
      def init_var
        super
        @option[:wrap_tag] ||= Ht.compact(".tab-content")
        @option[:item_tag] ||= Ht.compact(".tab-pane")
      end

      def add_tab(tab_id, content, opts = {})
        ht = Ht.compact(".tab-pane##{tab_id}", [ content ])
        EzLog.debug("TabContent: opts=#{opts}, ht=#{ht}")
        Ht.add_class(ht, opts[:add_class])
        @item_a.push(ht)
        return ht
      end
    end

    class Treeview < Ht::List
      def init_var
        @option[:wrap_tag] = Ht.compact("ul.nav.nav-treeview")
        @option[:item_tag] = Ht.compact("li.nav-item")
      end
    end

    class Dropdown < Ht::List
      def init_var
        @option[:wrap_tag] = Ht.compact(".dropdown")
      end

      def add_item(item, opts = {})
        ht = Ht.compact(item)
        Ht.add_class(ht, @option[:extra_item_class] || opts[:extra_item_class])
        @item_a.push(ht)
        return ht
      end

      def to_ht
        wrapper_ht = Ht.compact(@option[:wrap_tag])
        Ht.connect_child(wrapper_ht, @item_a)
        Ht.add_class(wrapper_ht, @option[:extra_wrap_class])
        return wrapper_ht
      end
    end

    class Form
      attr_accessor :action, :method, :append, :prepend

      def initialize(opts = {})
        @option = opts
        @option[:wrap_tag] ||= Ht.compact("form:method=post")
        @form_group_a = []
      end

      def add_input(input, opts = {})
        input = Ht.compact(input) if input.is_a?(String)
        label_class = nil
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
          # EzLog.debug("has label: #{label}")
          if @use_label_tag
            label_ht = Ht.label(label)
            Ht.add_class(label_ht, label_class) if label_class
            inpgrp.add_prepend(label_ht)
          else
            inpgrp.add_prepend(Ht.compact("span.input-group-text:#{label}"))
          end
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
        form = Ht.compact(@option[:wrap_tag])
        # form[:action] = @action
        # form[:method] = @method || "POST"
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
        Ht.connect_child(form, children)
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
          ht = Ht.compact(item)
          @input_a.push(ht)
        end

        def add_prepend(item, opts = {}) 
          ht = Ht.compact(item)
          @prepend ||= []
          @prepend.push(ht)
          return @prepend
        end

        def add_append(item, opts = {})
          ht = Ht.compact(item)
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

      class FormGroup < Ht::List
        def init_var
          super
          @option[:wrap_tag] ||= Ht.compact(".form-group")
          @option[:item_tag] ||= nil
        end
      end
    end

    class Breadcrumb < Ht::List
      def initialize(opts = {})
        super(opts)
        @option[:wrap_tag] ||= Ht.compact("ol.breadcrumb")
        @option[:item_tag] ||= Ht.compact("li.breadcrumb-item")
      end
    end

    class Card < Ht::List
      attr_accessor :title, :header

      def initialize(opts = {})
        super(opts)
        @option[:wrap_tag] = Ht.compact(".card > .card-body")
        @option[:item_tag] = Ht.compact("p.card-text")
      end

      def add_link(link)
        @link_a ||= []
        @link_a.push(link)
      end

      def to_ht
        stash = { prepend: @prepend.clone, append: @append.clone }
        if @title
          @prepend ||= []
          @prepend.push(Ht.compact("h5.card-title:#{@title}")) 
        end
        if @link_a
          links = @link_a.map do |lk|
            h = Ht.compact(lk)
            Ht.add_class(h, "card-link") if h[:tag] == :a
            h
          end
          @append = links
        end
        ht = super
        @prepend, @append = stash[:prepend], stash[:append]
        if @header
          card = Ht.search(ht, ".card")
          card[:child].unshift(Ht.compact(".card-header", [@header]))
        end
        return ht
      end
    end

    class CardTab
      def initialize
        @tab_a = []
        @content_a = []
      end

      def add_tab(id, name, content)
        data = { id: id, name: name, content: content}
        @tab_a.push(data)
      end

      def to_ht
        @tab_a[0][:active] = ".active"
        tab_list = @tab_a.map do |data| 
          "li.nav-item > a.nav-link#{data[:active]}:data-toggle=[pill]:href=#[#{data[:id]}]:#{data[:name]}"
        end
        tab_content = []
        @tab_a.each do |data|
          content = data[:content]
          content = [ content ] unless content.is_a?(Array)
          tab_content += ["##{data[:id]}.tab-pane#{data[:active]}", content ]
        end
        return Ht.compact(".card.card-primary.card-outline.card-tabs", [ 
          ".card-header > ul.nav.nav-tabs:role=[tablist]", tab_list,
          ".card-body > .tab-content", tab_content
        ])
      end
    end
  end
end
