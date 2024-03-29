Chef Cookbook Versions Handler
==============================

This cookbook installs a [Chef report handler](http://docs.opscode.com/essentials_handlers.html) to log the cookbooks and versions run on the node as part of the Chef run.

Requirements
============

Runs on any platform that Chef runs on.

Depends on the `chef_handler` community cookbook.

Usage
=====

default
-------

Put the recipe `cookbook_versions_handler` early in your run list so that it's registered with the Chef run.
Sample output:

   [2013-11-26T03:11:06+00:00] INFO: Chef Run complete in 0.300029878 seconds
   [2013-11-26T03:11:06+00:00] INFO: Running report handlers
   [2013-11-26T03:11:06+00:00] INFO: Cookbooks and versions run: ["chef_handler 1.1.4", "cookbook_versions_handler 1.0.0"]
   [2013-11-26T03:11:06+00:00] INFO: Report handlers complete

License and Author
==================

Author:: Julian C. Dunn (<jdunn@opscode.com>)

Copyright:: 2013, Opscode, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
