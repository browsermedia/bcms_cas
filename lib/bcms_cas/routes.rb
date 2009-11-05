module Cms::Routes
  def routes_for_bcms_cas
    namespace(:cms) do |cms|
      #cms.content_blocks :cas
    end  
  end
end
