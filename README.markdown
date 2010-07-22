# Central Authentication Server Module

This module allows BrowserCMS to integrate with a Central Authentication Server (CAS) to allow users to log in to a BrowserCMS site,
using credentials stored in an external system. This module requires an existing CAS server to be running (See http://code.google.com/p/rubycas-server/)
as an example of a server.

This module will allow user to login to the public area of the CMS, using the Login Form Portlet. It does not handle users that need to
log into the CMS administrative area. It also handles single logout by redirecting the user to cas /logout service.

As of 1.0.1, this is now managed via gemcutter.

## A. Instructions
Here are the necessary steps to install this module.

1. Configure your CAS server and test that you can login directly via their /login page.
2. Install the rubycas-client gem (See B below)
3. Install the bcms_cas module, and configure it to point to your CAS server (see C below).
4. Migrate the database to add the CAS Group (See D below)
5. Alter the Login Form Portlet to submit to the CAS server. (See E below)

## B. Installing RubyCAS-Client
This project depends on RubyCAS-client (http://code.google.com/p/rubycas-client/). RubyCAS-Client is a standard Rails PluginGem, and the instructions
for installing in into a Rails project can be found on their website. The following command will probably work though:

    gem install rubycas-client

This will add the latest version of a gem. The bcms_cas module will require the necessary files, so you do not need to
make any configuration changes in your rails project.

## C. Installing/Configuring the Module
To install a BrowserCMS module follow the instructions here http://www.browsercms.org/doc/guides/html/installing_modules.html .
After that you will need to configure the rubycas-client to point to the correct CAS server, along with any other
configuration options you need. Add the following to your config/initializers/browsercms.rb:


    CASClient::Frameworks::Rails::Filter.configure(
      :cas_base_url => "https://cas.yourdomainname.org",
      :extra_attributes_session_key => :cas_extra_attributes
    )

Make sure your SITE_DOMAIN variable in production/development is correctly set to the right top level domain. This will be needed
to allow redirects between the servers to happen correctly (it requires Absolute URLs). For example, in config/environments/production.rb:

    SITE_DOMAIN="www.yourdomainname.com"

### Extra Attributes (Optional)
The :extra_attributes_session_key may not be needed, depending on what type of Authenticator your CAS server is using. You can
safely leave it out if you are just using the normal CMS logic. A CAS server can send additional information back, and these will be stored as
session variables that can be accessed in other methods.

## D. Add/Configure the 'CAS Authenticated User' Group
When you run rake db:migrate, this module will add a new group to the CMS called 'CAS Authenticated Users'. All users that
log in successfully will be assigned to members of this group. You will potentially want to rename this group to something
that more accurately reflects who these users are (i.e. Members, Staff, etc) and then set which sections of the website this
group can visit.

## E. Configure Login Form Portlet
Alter the Login Form portlet to look something like this (or add a file to your project called app/views/portlets/login/render.html.erb with the following content):

    <% form_tag "https://cas.yourdomainname.org" do %>
        <%= login_ticket_tag %>
        <%= service_url_tag %>
        <p>
            <%= label_tag :login %>
            <%= text_field_tag :username, @login %>
        </p>
        <p>
            <%= label_tag :password %>
            <%= password_field_tag :password %>
            </p>
        <p>
            <%= label_tag :remember_me %>
            <%= check_box_tag :remember_me, '1', @remember_me %>
        </p>
        <p><%= submit_tag "Login" %></p>
    <% end %>

The key changes are:

1. The form needs to submit directly to the CAS server
2. You need to add helpers for login_ticket_tag and service_url_tag. These generate hidden parameters CAS services need.
3. Change the username parameter from :login to :username

You must also create a file in your project called: app/portlets/helpers/login_portlet_helper.rb, with the following contents:

    module LoginPortletHelper
      include Cas::LoginPortlet
    end

This will add the needed methods for the above class.

F. Known Issues

* Every page is secured by the CASClient Gateway Filter, which means a lot of redirects. This is potentially a big performance hit, and would require modifying the filter so it only handles checking login_tickets, rather than redirects. 
* A user logged in using CAS will be assigned to a single group. There is no way to map a user to different groups (i.e. Platnium or Gold Members). Could potentially be done via cas extra info.
* The internal CMS User database is bypassed/not used for login for front end pages. This means it would fail the cmsadmin user tried to login via the Login Form.
* [Low] LoginPortlet Form tag should pull from CAS automatically (requires changes to CMS core)
* [Low] username/login field is different between CMS and CAS (requires core changes)
* The CAS Login page has to be styled to match the look and feel of the site.
* If the user types in wrong username/pw on CMS login form, they will be left on the CAS Login page, with message.
* Every hit to a page with the login form portlet is fetching a LT from CAS. This is potentially slow. [Performance]

