# Central Authentication Server Module

This module allows BrowserCMS to integrate with a Central Authentication Server (CAS) to allow users to log in to a BrowserCMS site, using credentials stored in an external system. This module requires an existing CAS server to be running (See http://code.google.com/p/rubycas-server/) as an example of a server.

This module will allow user to login to the public area of the CMS, using the Login Form Portlet. It does not handle users that need to log into the CMS administrative area. It also handles single logout by redirecting the user to cas /logout service.

## Installation Instructions

Here are the necessary steps to install this module.

1. Install the bcms_cas module, and configure it to point to your CAS server (see B below).
2. Configure your CAS server and test that you can login directly via their /login page.
3. Migrate the database to add the CAS Group 
4. Create a Login Form to submit to the CAS server. 

## 1. Installing the Module

Install the module by running the following command in your project.

    $ gem install bcms_cas
    $ rails g cms:install bcms_cas
	$ rake db:seed

This should install the bcms_cas gem along with all its dependencies. The db:seed will add a new group to the CMS

See http://www.browsercms.org/doc/guides/html/installing_modules.html for more information on how to install modules generally.

## 2. Configure the CAS server

Edit the config/environments/development.rb file to include the following:

	config.bcms_cas_server = "https://cas.some-domain.com"
	
If you are using the same cas server for each environment (development, production, testing) you can configure this once in the config/application.rb, otherwise edit each environment file separate. 

Go to your CAS domain and test that you can log in.

## 2a. Ensure SITE_DOMAIN is configured.

Edit the production.rb to make sure your SITE_DOMAIN variable in production is correctly set to the right top level domain. This will be needed to allow redirects between the servers to happen correctly (it requires Absolute URLs).

    SITE_DOMAIN="www.yourdomainname.com"

## 3. Configure the 'CAS Authenticated User' Group
When you run rake db:migrate, this module will add a new group to the CMS called 'CAS Authenticated Users'. All users that
log in successfully will be assigned to members of this group. You will potentially want to rename this group to something
that more accurately reflects who these users are (i.e. Members, Staff, etc) and then set which sections of the website this
group can visit.

## 4. Create a Login Form

Via the BrowserCMS UI, create a page and place a Login Form portlet on it. It should use the newly generated login view created by the bcms_cas generator. If the module is configured correctly, then logging in should correctly establish a CAS session.

## Known Issues

* Every page is secured by the CASClient Gateway Filter, which means a lot of redirects. This is potentially a big performance hit, and would require modifying the filter so it only handles checking login_tickets, rather than redirects. 
* A user logged in using CAS will be assigned to a single group. There is no way to map a user to different groups (i.e. Platnium or Gold Members). Could potentially be done via cas extra info.
* The internal CMS User database is bypassed/not used for login for front end pages. This means it would fail the cmsadmin user tried to login via the Login Form.
* [Low] username/login field is different between CMS and CAS (requires core changes)
* The CAS Login page has to be styled to match the look and feel of the site.
* If the user types in wrong username/pw on CMS login form, they will be left on the CAS Login page, with message.
* Every hit to a page with the login form portlet is fetching a LT from CAS. This is potentially slow. [Performance]
* A user that logs in as a CAS user and then as a cmsadmin will experience odd UI permission problems. This is due to CMS login not correctly clearing all session state.

