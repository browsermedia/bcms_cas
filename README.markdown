# CAS Module

This module allows BrowserCMS to integrate with a Central Authentication Server (CAS) to allow users to log in to a BrowserCMS site,
using credentials stored in an external system. This module requires an existing CAS server to be running (See http://code.google.com/p/rubycas-server/)
as an example of a server.

## A. Instructions
There are two basic steps to setting up this module.

1. Configure your CAS server.
2. Install the module like any other BrowserCMS module, and configure it to point to the CAS server of your choice.


## B. Notes
This project relies on CASClient (http://code.google.com/p/rubycas-client/) which is packaged as part of the gem.