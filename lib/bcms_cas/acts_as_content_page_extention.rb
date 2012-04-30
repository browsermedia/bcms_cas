module Cas
  module Acts
    module ContentPage

      def try_to_stream_file
        # Do nothing. Needed to avoid breakage for actions that include Cms::Authentication as well as Cms::Act::ContentPage.
      end
    end
  end
end
