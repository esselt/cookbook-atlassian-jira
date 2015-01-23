Description
============

Cookbook to install Atlassian Jira

Requirements
============

Chef version 11.0+

## Platform

Supported platforms by platform family:

* debian (debian, ubuntu)

## Cookbooks

This cookbook needs the following cookbooks:

* [apache2](https://github.com/opscode-cookbooks/apache2) (opscode)

Attributes
==========

SHOULD UPDATE THIS

Usage
=====

## atlassian-jira::default

Description

Example role

    name 'myclient'
    run_list(
      'recipe[atlassian-jira::default]'
    )
    default_attributes(
      'atlassian-jira' => {

      }
    )


License and Authors
===================
Author:: Boye Holden (<boye.holden@hist.no>)

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.