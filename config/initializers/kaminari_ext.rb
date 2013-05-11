module Kaminari
  module Helpers
    class Tag
      def page_url_for(page)
        @template.url_for @params.merge(@param_name => (page))
      end
    end
    class Paginator
      def render(&block)
        instance_eval(&block) if @options[:total_pages] >= 1
        @output_buffer
      end
    end
  end
end
