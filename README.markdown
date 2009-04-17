HttpNotifier
============

A (very) simple HTTP notifier plugin for cruisecontrol.rb.

### Configuration

In your project's `cruise_config.rb` add the following options:

    # The url to make request to
    project.http_notifier.url = "http://foobar.com/status"

    # Use HTTP basic auth.
    project.http_notifier.use_basic_auth = true

    # The http username and password if use_basic_auth is set to true.
    project.http_notifier.http_user = "foobar"
    project.http_notifier.http_password = "secret"

    # Extra parameters that will be added to every HTTP request.
    project.http_notifier.extra_params = { :title => 'Build Status' } 
    

### Request

This plugin will make an HTTP request after the completiton of a build, with an
HTTP query parameter of `status` and a value of:

    PROJECT_NAME build BUILD_LABEL failed.

or 

    PROJECT_NAME build BUILD_LABEL fixed.




Written to scratch an itch by Ry Wharton.

Use at your own risk. 

Find the latest version on [Github](http://github.com/ryland/ccrb_http_notifier).

