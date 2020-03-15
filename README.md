# Prometheus Cookbook

This is an opinionated cookbook to run [prometheus](https://prometheus.io/) in a production environment.  Defaults are written to `/etc/default` and everything runs under the `prometheus` _user_.

Requirements
======

Debian based Linux Distribution using Systemd such as:
  - Ubuntu `16.04`
  - Ubuntu `18.04`

Resources and Providers
-----
`monitor.rb`  
`alertmanager.rb`  
`exporter.rb`  
------

Install or configure or start the Prometheus service using this resource.

Actions:

* `create` - Downloads Prometheus and installs it in `/opt/prometheus/bin`.  This action also starts prometheus.

### monitor::create
| Attribute          | Type   | Description                                                      | Default                                                                                                   | Required |
|--------------------|--------|------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------|----------|
| version            | String | Version of Prometheus to install                                 | `2.16.0`                                                                                                  | Yes      |
| checksum           | String | sha256 sum of the binary release                                 |                                                                                                           | Yes      |
| uri                | String | URI to Download Prometheus from                                  | `https://github.com/prometheus/prometheus/releases/download/v2.16.0/prometheus-2.16.0.linux-amd64.tar.gz` | Yes      |
| home_dir           | String | Home directory for prometheus user                               | `/opt/prometheus`                                                                                         | Yes      |
| cookbook           | String | Indicated which cookbook holds `prometheus.conf.erb`             | `prometheus`                                                                                              | Yes      |
| filename           | String | The filename of the downloaded archive from the uri              |                                                                                                           | Yes      |
| pathname           | String | The path created by the downloaded archive after being extracted |                                                                                                           | Yes      |
| arguments          | Array  | Command line arguments to start prometheus with                  | `['--config.file="/etc/prometheus/prometheus.yml"']`                                                      | Yes      |
| template_name      | String | Filename of the template for `/etc/default/prometheus`           | `prometheus.erb`                                                                                          | Yes      |
| cookbook           | String | Indicated which cookbook holds `prometheus.conf.erb`             | `prometheus`                                                                                              | Yes      |

### alertmanager::create
| Attribute     | Type   | Description                                                      | Default                                                                                                       | Required |
|---------------|--------|------------------------------------------------------------------|---------------------------------------------------------------------------------------------------------------|----------|
| version       | String | Version of Alertmanager to install                               | `0.20.0`                                                                                                      | Yes      |
| checksum      | String | Checksum of Alertmanager tarball                                 | `5f17155d669a8d2243b0d179fa46e609e0566876afd0afb09311a8bc7987ab15`                                            | Yes      |
| uri           | String | URI to Download Alertmanager From                                | `https://github.com/prometheus/alertmanager/releases/download/v0.20.0/alertmanager-0.20.0.linux-amd64.tar.gz` | Yes      |
| home_dir      | String | Home Directory for Prometheus User                               | `/opt/prometheus`                                                                                             | Yes      |
| filename      | String | The filename of the downloaded archive from the uri              |                                                                                                               | Yes      |
| pathname      | String | The path created by the downloaded archive after being extracted |                                                                                                               | Yes      |
| cookbook      | String | Cookbook name that holds the prometheus.erb template             | `prometheus`                                                                                                  | Yes      |
| template_name | String | Template name if you don't want to use `prometheus.erb`          | `prometheus.erb`                                                                                              | Yes      |
| arguments     | String | Arguments to start Alertmanager with                             | `--config.file="/etc/prometheus/alertmanager.yml"`                                                            | Yes      |

### exporter::create
| Attribute     | Type   | Description                                                                  | Default           | Required |
|---------------|--------|------------------------------------------------------------------------------|-------------------|----------|
| checksum      | String | sha256sum of the exporter tarball                                            |                   | Yes      |
| uri           | String | URI to Download the exporter from                                            |                   | Yes      |
| filename      | String | The filename of the downloaded archive from the uri                          |                   | Yes      |
| pathname      | String | The path created by the downloaded archive after being extracted             |                   | Yes      |
| cookbook      | String | Name of the cookbook that holds the prometheus.erb template                  | `prometheus`      | Yes      |
| template_name | String | Name of the template to be used to create `/etc/default/prometheus-$example` | `prometheus.erb`  | Yes      |
| arguments     | Array  | Command line arguments to start the exporter with                            | []                | Yes      |
| home_dir      | String | Home directory for the prometheus user                                       | `/opt/prometheus` | Yes      |
| binaries      | Array  | List of the binaries to be installed for the exporter to function            | []                | Yes      |
| start_command | String | Name of the binary to start the exporter                                     |                   |          |
| dsn           | String | If using the mysqld exporter use this to set your data source                |                   | No       |


Usage
-----

This cookbook will help you monitor your systems using Prometheus. An example is below

```ruby
directory "/etc/prometheus" do
  action :create
end
cookbook_file "/etc/prometheus/prometheus.yml" do
  source "prometheus.yml"
end
dummynodes=[{"labels"=>{"job"=>"node"}, "targets"=>["localhost:9100"]}]
file "/etc/prometheus/targets.json" do
  content dummynodes.to_json
end
cookbook_file '/etc/prometheus/rules1.rules' do
  source 'rules1.rules'
end
prometheus_monitor "default" do
  version "2.16.0"
  action :create
  uri 'https://github.com/prometheus/prometheus/releases/download/v2.16.0/prometheus-2.16.0.linux-amd64.tar.gz'
  checksum 'c04e631d18e186b66a51cac3062157298e037ffae784f35ccaaf29e496d65d3f'
  filename 'prometheus-2.16.0.linux-amd64.tar.gz'
  pathname 'prometheus-2.16.0.linux-amd64'
  arguments ["--config.file='/etc/prometheus/prometheus.yml'","--storage.tsdb.retention=30d"]
  action :create
end
service "prometheus_restart" do
service_name "prometheus"
action :start
provider Chef::Provider::Service::Systemd
subscribes :restart, "template[/etc/prometheus/prometheus.yml", :delayed
end
```

Further [examples can be found here](https://github.com/damm/prometheus/tree/master/test/cookbooks/test_prom/recipes)

License and Author
-------------------

Author:: Scott Likens (<scott@likens.us>)

Copyright 2020 Scott M. Likens

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.  See the License for the specific language governing permissions and limitations under the License.
