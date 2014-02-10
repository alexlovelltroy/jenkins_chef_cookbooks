jenkins_chef_cookbooks
======================

A collection of cookbooks used to set up a Jenkins server. You can point to this repo with OpsWorks if you want to create a custom Jenkins layer.

Most of these cookbooks are just copies of open source cookbooks. They were retrieved using berkshelf, since it makes everything way easier. If you need to update the open source cookbooks, it's simple enough; just add the new dependency to Berksfile, and then run these commands:

```
gem install berkshelf
berks install --path temp
cp -R temp/* .
rm -rf temp
```

(berkshelf seemed to nuke the directory that you pass in with --path, so don't just try passing in the current directory. That took me a little while to figure out...)

---

The custom cookbooks are as follows:
* jenkins-configuration: cookbooks to configure Jenkins jobs, views, etc.
* rvm: the one berkshelf pulls in is wicked old, and the override wasn't working. I just downloaded it manually.

how to use this repository
======================

This repository is design to be used as the custom Chef cookbooks repository for a Jenkins stack built using Amazon's OpsWorks service. I suppose you could use it to build a custom Jenkins server without using OpsWorks, but I haven't tried that so if you give it a shot you're on your own. :)

If you're building your OpsWorks script using the Ruby SDK, it'll look something like this:

    stack_params = {
      name: "Jenkins Server", 
      region: "us-west-2", 
      default_os: 'Amazon Linux',
      service_role_arn: 'arn:aws:iam::123467890:role/aws-opsworks-service-role', 
      default_instance_profile_arn: 'arn:aws:iam::123467890:instance-profile/jenkins',
      custom_json: custom_json,
      use_custom_cookbooks: true,
      custom_cookbooks_source: {
          type: 'git',
          url: 'https://github.com/stelligent/jenkins_chef_cookbooks.git'
        }
    }

    stack = ops.create_stack stack_params

how to update jenkins configuration:
====

If you've made changes to the Jenkins server configuration, it will not be persisted if the server goes down. If you'd like to commit that configuration to a source control repo, fork this repo and look in the jenkins-configuration cookbook. In there you will find various ERB template files, each full of XML. These are the raw Jenkins configuration files. You can find this XML by configuring the jobs on the Jenkins server, and then changing the URL. The Jenkins job configure URL will end in /jobname/configure; if you go to /jobname/config.xml you'll see the pure XML. 

The templates don't do much templating (only the source control repo URL) so you can just copy the XML and paste it into the template file.

**Note**: The groovy scripts that inject the job configuration will crash and burn if there is any whitespace at the beginning of the file. Make sure that there isn't any whitespace at the beginning of the XML document. 

questions?
====
If you have any issues, feel free to open an issue or make a pull request. Alternatively, you can reach out on twitter: @jonathansywulak

:books: 

## LICENSE

Copyright (c) 2014 Stelligent Systems LLC

MIT LICENSE

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.