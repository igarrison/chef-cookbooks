Snekmon Cookbook for Chef
===========================
![Alt text](https://github.com/igarrison/chef-cookbooks/blob/master/snekmon/images/snekmon_system.png "Raspberry Pi Snake Monitoring and Alerting")

The snekmon chef cookbook is a couple python scripts deployed via chef as part of an overengineered solution for long term historical monitoring and alerting of the temperature and humidity inside my cornsnake's vivarium.

My goals were to visualize temperatures over different time periods as long as a few years and see the seasonal temperature changes between summer and winter.  I also wanted to get alerts to my smartphone so that when I was away from the house at work it could help reinforce awareness of when conditions might be uncomfortably hot or cold for my ectothermic friend.  I like chef and wanted to learn about test kitchen and serverspec and this looked like something that could easily be plugged into my existing graphite server.

**WARNING**: This cookbook was created for my own use after my rpi's filesystem corrupted as a means to more quickly redeploy it.  Its tailored for my use, but if you know the basics of both chef and python you can make it suit your own use.

Temperature and humidity are at the core of reptile keeping.  The idea here is that 3 temperature probes should be placed with one at the hot side, center, and cool side which allows us to visualize the temperature gradient within the vivarium.  Once metrics are collected its trivial to look at temperatures over different time periods.  You could take your snake to a vet with graphs from the last 15 days, last 6 weeks, last 18 months, and last 5 years -- your reptile husbandry is auditable over long periods of time.  

Prowl Mobile Notifications
--------------------------
The mechanism by which push notifications are sent to your smartphone is with a prowlapp.com API key and alerter python script.

![Alt text](https://github.com/igarrison/chef-cookbooks/blob/master/snekmon/images/prowlapp.png "Prowlapp")

Hardware Requirements and Costs
---------------------
- Raspberry Pi (models B+ or 2, 4 USB ports required) to run the poller.  Cost: rpi2 should be around $35, $10 for a case, $10 for an edimax wifi adapter, $10 for micro USB adapter, $10 for a USB micro card reader to load Raspbian, $10 for a 16GB microSD card, another $10 for an HDMI cable -- Total ~$95.00 USD 
- 2x TEMPer1 or Temper2 USB probes can be found on [Newegg](http://www.newegg.com/Product/Product.aspx?Item=9SIA3XT1D88504) for $22.09 each are supported by https://github.com/padelt/temper-python
- 1x TEMPERHUM1v1.0 USB probe can be found on [Amazon](http://www.amazon.com/Generic-TEMPerHUM-Thermometer-Temperature-Recorder/dp/B00HWP8U44/) for $26.49 and is supported by https://github.com/edorfaus/TEMPered which depends on https://github.com/signal11/hidapi
- PC Server, could be another box on the LAN, a virtual machine on a desktop or workstation that is always online, or an Amazon EC2 or other cloud compute server instance (~50/mo for an m3.medium EC2 instance).  This will be the graphite server which you are expected to setup on your own.  The graphite server can also run the alerter script that this cookbook deploys.  There is even a [Hosted Graphite SaaS Provider](https://www.hostedgraphite.com/) with their smallest account being $19/mo although I haven't tested it.  I won't include cost of this item as it varies greatly depending on what you have or what you want.
- Expect to spend as much as $170 on the rpi2 and probes, and more if you don't have reliable place to run a graphite server.  Its a bit costly, but there are no software costs and the rpi could be further expanded to capture pictures/video and other tasks.  If any components break they are relatively cheap and easy to replace.
![Alt text](https://github.com/igarrison/chef-cookbooks/blob/master/snekmon/images/vivarium_empty.png "Raspberry Pi Snake Monitoring and Alerting")

Software Requirements
---------------------
- A Graphite Server is needed to receive stats from the poller and to also run the alerter.  I used https://github.com/opscode-cookbooks/oc-graphite and https://github.com/JonathanTron/chef-grafana (grafana is optional, it makes graphite pretty).  This is the one thing that this cookbook does not setup for you.
- http://prowlapp.com account with an API key is supported by https://github.com/jacobb/prowlpy.  Accounts are free.
- Network accessible package and source repositories
- Python was selected for the scripts as its the most ironic
- A chef server reachable on the network or internet that your graphite server and raspberry pi are bootstrapped to.  If you don't already have a chef server [Hosted Chef](https://manage.chef.io/signup) provides the first five nodes for free so you don't have to run a server (which is free up to 25 nodes).

Cookbook Dependencies
---------------------
- apt
- rsyslog
- runit
- git
- cron

Platform Support
----------------
The following platforms have been tested with test kitchen and serverspec:

```
|----------------+--------+---------|
|                | poller | alerter |
|----------------+--------+---------|
| Raspbian 7     |   X    |    X    |
|----------------+--------+---------|
| ubuntu-14.04   |   X    |    X    |
|----------------+--------+---------|
```

Attributes
----------
#### snekmon::default
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['snekmon']['graphite_address']</tt></td>
    <td>ipv4 address or hostname</td>
    <td>For chef solo users or those who don't want to rely on search to find the graphite server in your chef organization you can use this attribute.</td>
    <td><tt>nil</tt></td>
  </tr>
  <tr>
    <td><tt>['snekmon']['graphite_searchrole']</tt></td>
    <td>chef role</td>
    <td>Role to search your chef organizations to find your graphite-server.  To prevent graphite servers from being picked up in search by either using the graphite_address attribute above or tagging a graphite server with tag:no-monitor.</td>
    <td><tt>graphite-server</tt></td>
  </tr>
  <tr>
    <td><tt>['snekmon']['graphite_port']</tt></td>
    <td>integer</td>
    <td>The port your graphite server accepts requests on.</td>
    <td><tt>2003</tt></td>
  </tr>
  <tr>
    <td><tt>['snekmon']['graphite_userurl']</tt></td>
    <td>URL</td>
    <td>When a prowl alert is received include this URL in the notifications so the user can choose to click on it to see any dashboards, graphs, trends, or other useful information.</td>
    <td><tt>https://grafana.example.com</tt></td>
  </tr>
  <tr>
    <td><tt>['snekmon']['prowlapi_key']</tt></td>
    <td>API key</td>
    <td>When you have a prowlapp.com account and have launched your smartphone prowl app and logged in to associate the device with your account you can retrieve your API key which is needed to push notifications to your smartphone.</td>
    <td><tt>s3kret</tt></td>
  </tr>
  <tr>
    <td><tt>['snekmon']['poll_interval']</tt></td>
    <td>integer in seconds</td>
    <td>The interval in seconds that the poller python script runs.  Depending on the speed of your rpi might not take this below 10 seconds.</td>
    <td><tt>60</tt></td>
  </tr>
    <tr>
    <td><tt>['snekmon']['hotside_toohot']</tt></td>
    <td>temperature in Fahrenheit</td>
    <td>If the hot side gets over this temperature send an alert.</td>
    <td><tt>90</tt></td>
  </tr>
  <tr>
    <td><tt>['snekmon']['hotside_toocold']</tt></td>
    <td>temperature in Fahrenheit</td>
    <td>If the hot side is under this temperature there might be a problem that warrants investigation (UTH or thermostat issue?).</td>
    <td><tt>75</tt></td>
  </tr>
  <tr>
    <td><tt>['snekmon']['coolside_toocold']</tt></td>
    <td>temperature in Fahrenheit</td>
    <td>If the cool side gets below this temperature there might be a problem with the overall temperature of the house (Cold winter drafts and poor heating schedule?)</td>
    <td><tt>59</tt></td>
  </tr>
  <tr>
    <td><tt>['snekmon']['center_lowhumid']</tt></td>
    <td>percentage</td>
    <td>This probe I put in the humid hide in the center of the vivariumr.  For my corn snake %40+ humidity is sufficient for healthy shedding but with the humid hide I can offer higher humidity in a localized area in the viv the snake can use as he wants.</td>
    <td><tt>39</tt></td>
  </tr>
</table>

Usage
-----
#### snekmon::default
This recipe does nothing.  Do not use it!  It is a trick to hopefully be mindful that you need to choose either snekmon::poller or snekmon::alerter and understand their purposes.

#### snekmon::poller
This runs on a raspberry pi with the 3 USB temp/humidity probes connected to it.  Runit does the process supervision and restarts it in case it ever dies.  Logs are in /var/log/snekmon. The raspberry pi device collects the metrics and sends them over the network to your graphite server.

By default the poller runs on the pi every 60 seconds.  Technically it can run as frequently as every 10 seconds with nothing else running on the pi.

#### snekmon::alerter
This can run anywhere in your environment that can talk to your graphite server and prowlapp.com for sending push notifications to your smartphone.  I run the alerter right on my graphite server, but you could run it on the raspberry pi as well.  Right now only prowlapp.com push notifications to a smartphone is supported.  For alerting to work you are expected to already have an account on prowlapp.com and have provided your API key as an attribute `prowlapi_key`.  This script queries all the reptile environment metrics over the last hour and sends the prowl alerts for violations outside the range set in chef attributes.

In addition to putting the poller and/or alerting recipe on a node there probably are some other attributes you will want to overrite (see: attributes for the rest):
```json
{
  "override_attributes": {
    "snekmon": {
      "graphite_userurl": "https://grafana.example.com",
      "prowlapi_key": "0101sekret010101"
    },
  },
  "run_list": [
    "recipe[snekmon::poller]",
    "recipe[snekmon::alerting]"
  ]
}
```

Contributing
------------
1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write your change
4. Submit a Pull Request using Github

License and Authors
-------------------
- Author:: Ian Garrison (<garrison@technoendo.net>)

```text
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```

Graphite and Grafana?
---------------------
Yes, you are expected to have setup or aquired a graphite server on your own.  You do not need to put a grafana or other dashboard in front of it if you don't want to.  The poller script just needs to be able to submit stats to the graphite port, and the alerting script needs to hit the [http api](http://graphite.readthedocs.org/en/1.0/url-api.html) to make requests similar to the one below (except using python http libraries instead of curl):

```
$ curl "http://localhost/render?target=system.pi.reptile_hottemperature&from=-1hours&format=raw"

system.pi.reptile_hottemperature,1409887440,1409891040,60|80.7,80.7,80.7,80.7,
83.6,84.8,85.9,86.2,86.3,85.9,85.3,84.7,83.6,81.2,80.7,80.7,80.7,80.7,80.7,80.7,
80.7,82.2,84.0,85.0,85.8,86.5,86.6,85.9,85.7,84.8,83.5,82.4,80.7,80.7,80.7,80.7,
80.7,80.7,80.7,83.1,84.7,85.8,86.2,86.8,86.7,86.2,85.9,84.8,83.6,81.7,80.7,80.7,
80.7,80.7,80.7,80.7,80.7,83.5,84.8,85.9
```

If you do put grafana in front of graphite you can see it can make for some pretty dashboards:
![Alt text](https://github.com/igarrison/chef-cookbooks/blob/master/snekmon/images/grafana_dashboard.png "Grafana Dashboard front end for Graphite to visualize Reptile Environmentals")

Additional Notes on Probes
--------------------------
Apparently there are multiple versions/brands of these probes floating around out there but these Microdia ones worked great.

```
# lsusb | grep Microdia
Bus 001 Device 015: ID 0c45:7402 Microdia TEMPerHUM Temperature & Humidity Sensor
Bus 001 Device 005: ID 0c45:7401 Microdia
Bus 001 Device 007: ID 0c45:7401 Microdia
```

Snips from dmesg on the probes:

```
[    3.416382] usb 1-1.2: Product: TEMPERHUM1V1.0
[    3.448608] input: RDing TEMPERHUM1V1.0 as /devices/platform/bcm2708_usb/usb1/1-1/1-1.2/1-1.2:1.0/input/input0
[    3.463833] hid-generic 0003:0C45:7402.0001: input,hidraw0: USB HID v1.10 Keyboard [RDing TEMPERHUM1V1.0] on usb-bcm2708_usb-1.2/input0
[    3.493789] hid-generic 0003:0C45:7402.0002: hiddev0,hidraw1: USB HID v1.10 Device [RDing TEMPERHUM1V1.0] on usb-bcm2708_usb-1.2/input1
[    3.762242] usb 1-1.3: Product: TEMPer1V1.4
[    3.796336] input: RDing TEMPer1V1.4 as /devices/platform/bcm2708_usb/usb1/1-1/1-1.3/1-1.3:1.0/input/input1
[    3.814486] hid-generic 0003:0C45:7401.0003: input,hidraw2: USB HID v1.10 Keyboard [RDing TEMPer1V1.4] on usb-bcm2708_usb-1.3/input0
[    3.851730] hid-generic 0003:0C45:7401.0004: hiddev0,hidraw3: USB HID v1.10 Device [RDing TEMPer1V1.4] on usb-bcm2708_usb-1.3/input1
[    4.419773] usb 1-1.5: Product: TEMPer1V1.4
[    4.465831] input: RDing TEMPer1V1.4 as /devices/platform/bcm2708_usb/usb1/1-1/1-1.5/1-1.5:1.0/input/input2
[    4.497234] hid-generic 0003:0C45:7401.0005: input,hidraw4: USB HID v1.10 Keyboard [RDing TEMPer1V1.4] on usb-bcm2708_usb-1.5/input0
[    4.548672] hid-generic 0003:0C45:7401.0006: hiddev0,hidraw5: USB HID v1.10 Device [RDing TEMPer1V1.4] on usb-bcm2708_usb-1.5/input1
```

After building the tempered and temper-python github projects you can interact with the probes:

```
# /usr/local/bin/tempered --scale Fahrenheit
/dev/hidraw1 0: temperature 76.16 °F, relative humidity 51.5%, dew point 57.0 °F

# /usr/local/bin/temper-poll
Found 2 devices
Device #0: 27.1°C 80.7°F
Device #1: 22.1°C 71.7°F
```
