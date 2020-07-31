module Ezframe
  module Bootstrap
    class Navbar
      def initialize(opts = {})
        @option = opts
        @option[:wrap_tag] ||= "ul.navbar-nav"
        @option[:item_tag] ||= "li.nav-item"
        @items = []
      end

      def add_item(item, opts = {})
        wrapper_ht = Ht.from_array(@option[:item_tag]) || { tag: :div }
        item_ht = Ht.from_array(item)
        wrapper_ht[:child] = item_ht
        Ht.add_class(wrapper_ht, opts[:extra_item_class]) if opts[:extra_item_class]
        @items.push(wrapper_ht)
        return wrapper_ht
      end

      def to_ht
        wrapper_ht = Ht.from_array(@option[:wrap_tag])
        Ht.add_class(wrapper_ht, @option[:extra_wrap_class])
        wrapper_ht[:child] = @items
        return wrapper_ht
      end
    end

    class Form
      def initialize(opts)
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
          label_ht = Ht.add_class(label_ht, @label_class) if @label_class
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
        form = Ht.form(@option)
        form[:child] = @form_group_a.map do |grp|
          if grp.respond_to?(:to_ht)
            grp.to_ht
          else
            grp
          end
        end
        return form
      end

      class InputGroup
        attr_accessor :option, :label_class

        def initialize(opts = {})
          @option = opts
          @input_a = []
          return self
        end

        def add_item(item)
          @input_a.push(item)
        end

        def add_prepend(opts = {})
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