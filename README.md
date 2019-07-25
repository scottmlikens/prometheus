# Prometheus Cookbook

This cookbook can be used in part or whole to automate [prometheus](https://prometheus.io/) similar to how it is installed in Debian/Ubuntu.

Pull requests are always welcome to improve this cookbook
---------------

Requirements
======

Debian based Linux Distribution using Systemd such as:
  - Ubuntu `16.04`
  - Ubuntu `18.04`
  - Ubuntu `14.04` is supported for the node exporter only.

It is not tested on other environments but it may work.

Resources and Providers
-----
`monitor.rb`
------

Install or configure or start the Prometheus service using this resource.

Actions:

* `install` - Downloads Prometheus and installs it in `/usr/bin`
* `config` - Generates `/etc/prometheus/prometheus.yml` using Chef
> The configuration generator works with the simple configuration tested.  If you need more complex needs feel free to skip using this resource and manage the file how you see fit.

* `start` - Starts prometheus using Systemd

### monitor::install
| Attribute | Type | Description | Default | Required |
|--|--|--|--|--|
| version | String | Version of Prometheus to install | `2.10.0` | Yes |
| checksum | String | sha256 sum of the binary release | `f4233783826f18606b79e5cef0686e4a9c2030146a3c7ce134f0add09f5adcb7` | Yes |
| base_uri | String | Base URI to Download Prometheus from | https://github.com/prometheus/prometheus/releases/download/| Yes |
| home_dir | String | Home directory for prometheus user | `/opt/prometheus` | Yes |
| local_storage_path | String | Path where Prometheis stores the Bolt Database | `/var/lib/prometheus` | Yes |
| cookbook | String | Indicated which cookbook holds `prometheus.conf.erb` | `prometheus` | Yes |

### monitor::config
| Attribute | Type | Description | Default | Required |
|--|--|--|--|--|
| global | Hash | The Global Block of the Prometheus Configuration file | `{ "global"=>{"scrape_interval"=>"15s", "evaluation_interval"=>"15s", "external_labels"=>{"monitor"=>"Chef"}}}` | Yes |
| rule_files |  Array | Array of rule files to load | `[]` | No |
| scrape_configs| Array| Scrape Configuration block of the prometheus configuration files | `[{'job_name':"node", 'file_sd_configs':[{'files':["targets.json"]}]}]` | Yes |

### monitor::start
| Attribute | Type | Description | Default | Required |
|--|--|--|--|--|
| arguments | Array| Command line arguments to start prometheus with | `['--config.file="/etc/prometheus/prometheus.yml"']` | Yes |
| template_name | String | Filename of the template for `/etc/default/prometheus` | `prometheus.erb` | Yes |
| cookbook | String | Indicated which cookbook holds `prometheus.conf.erb` | `prometheus` | Yes |

### alertmanager::install
| Attribute | Type | Description | Default | Required |
|--|--|--|--|--|
| version | String | Version of Alertmanager to install | `0.18.0` | Yes |
| checksum | String | Checksum of Alertmanager tarball | `5f17155d669a8d2243b0d179fa46e609e0566876afd0afb09311a8bc7987ab15` | Yes |
| base_uri | String | Base URI to Download Alertmanager From | `https://github.com/prometheus/alertmanager/releases/download/` | Yes |
| home_dir | String | Home Directory for Prometheus User | `/opt/prometheus` | Yes |

### alertmanager::start
| Attribute | Type | Description | Default | Required |
|--|--|--|--|--|
| cookbook | String | Cookbook name that holds the prometheus.erb template | `prometheus` | Yes |
| template_name | String | Template name if you don't want to use `prometheus.erb` | `prometheus.erb` | Yes |
| arguments | String | Arguments to start Alertmanager with | `--config.file="/etc/prometheus/alertmanager.yml"` | Yes |


Usage
-----

This cookbook is intended to be a framework to help you monitor your systems.  A few examples are below:

```ruby
prometheus_monitor "default" do
  version "2.10.0"
  action :install
end
global_config={"scrape_interval"=>"15s", "evaluation_interval"=>"15s", "external_labels"=>{"monitor"=>"Test Kitchen"}}
prometheus_monitor "start" do
  arguments ["--config.file='/etc/prometheus/prometheus.yml'","--storage.tsdb.retention=30d"]
  action :start
end
dummynodes=[{"labels"=>{"job"=>"node"}, "targets"=>["localhost:9100"]}]
file "/etc/prometheus/targets.json" do
  content dummynodes.to_json
end
prometheus_monitor "config" do
  global global_config
  action :config
end
```

Alternatively you can ship the configuration file if the generator does not work for you.

```ruby
prometheus_monitor "default" do
  version "2.10.0"
  action :install
end
global_config={"scrape_interval"=>"15s", "evaluation_interval"=>"15s", "external_labels"=>{"monitor"=>"Test Kitchen"}}
prometheus_monitor "start" do
  arguments ["--config.file='/etc/prometheus/prometheus.yml'","--storage.tsdb.retention=30d"]
  action :start
end
template "/etc/prometheus/prometheus.yml" do
  source "prometheus.yml"
end
service_name "prometheus"
action [:start,:enable]
provider Chef::Provider::Service::Systemd
subscribes :restart, "template[/etc/prometheus/prometheus.yml", :delayed
end
```

License and Author
-------------------

Author:: Scott Likens (<scott@likens.us>)

Copyright 2019 Scott M. Likens

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.  See the License for the specific language governing permissions and limitations under the License.
