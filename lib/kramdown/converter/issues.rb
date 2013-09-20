module Kramdown

  module Converter

    class Issues < Base

      def initialize(root, options)
        super
        @stack = []
        @issues = []
      end

      def convert(el)
        trace_tree(el)
        @issues
      end

      def get_issue(tree)
        issue = Issue.new
        tree.children.each_with_index do |child, index|
          next if child.type == :blank
          if child.type == :ol
            @stack.push(child)
            issue.children = trace_tree(child) # get children issue
            issue.children.each {|c_issue|
              c_issue.parent = issue
            }
            @stack.pop
          else
            if child.type == :ul
              @stack.push(child)
              result = trace_tree(child).join
              @stack.pop
            else
              result = trace_tree(child).join.strip
            end
            if !issue.subject 
              issue.subject = result
            else
              issue.description += "* #{result}\n" 
            end
          end
        end
        @issues.push issue
        issue
      end

      def trace_tree(tree)
        if tree.children.length > 0
          tree.children.map do |child|
            if child.type == :ol
              @stack.push(child)
              # new ol scope
              trace_tree(child)
              @stack.pop
            elsif child.type == :ul
              puts child.inspect
              @stack.push(child)
              # new ul scope
              trace_tree(child)
              @stack.pop
            else
              if child.type == :li
                if @stack.last.type == :ol
                  # create issue
                  issue = get_issue(child)
                elsif @stack.last.type == :ul
                  # create issue content
                  trace_tree(child)
                end
              else
                trace_tree(child)
              end
            end
          end
        elsif tree.type == :text
          return tree.value
        end
      end

    end
  end
end
