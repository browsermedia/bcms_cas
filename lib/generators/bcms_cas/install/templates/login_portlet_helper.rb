# Necessary only while BrowserCMS can't load portlet helpers from gems. (Bug See https://browsermedia.lighthouseapp.com/projects/28481/tickets/280-loginportlethelper-methods-cant-be-found-in-loginportlet)
module LoginPortletHelper
  include Cas::LoginPortlet
end
