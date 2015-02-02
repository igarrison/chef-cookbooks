Snekmon Cookbook
===========================
The Snek Cookbook is for a very specific application where a raspberry pi B+ (4 usb ports required!) has a USB wifi module, 2 USB temp probes, and a USB combo humidity/temp probe to collect metrics and send them to a graphite server.  The poller runs on the raspberry pi, but as I don't see the rpi as a reliable place for long term storage the graphite server is run on virtual machine elsewhere on the lan.

3 temperature probes can be placed with one at the "hot side", "center", "cool side" and as the metrics go into our time series database we can get graphs for different periods of time quickly to visualize the temperature gradient that is vital to the care of reptiles.  I want to be able to have multiple years of data at 1 minute resolution and be more aware of things like seasonal variations in temperature.

Aside from visualization we also want to get smartphone push alerts via prowlapp.com if the averate temps and humidity over the last hour are outside acceptable ranges.

WARNING: This cookbook is for a very specific use and was created after my rpi's filesystem corrupted after 3 months of use.  This is a "quick & dirty" cookbook, there are no tests, its not using the best cookbook design patterns.

Requirements
------------
- Raspberry Pi B+ (runs poller)
- 2x TEMPer1V1.4 modules (Microdia is manufacturer per lsusb) are supported by https://github.com/padelt/temper-python
- 1x TEMPERHUM1v1.0 module (also Microdia) is supported by https://github.com/edorfaus/TEMPered
- External Graphite Server (can run alerter).  I used https://github.com/opscode-cookbooks/oc-graphite and https://github.com/JonathanTron/chef-grafana (grafana is optional, its a front-end dashboard that can make graphite very pretty)
- http://prowlapp.com account with an API key is supported by https://github.com/jacobb/prowlpy
- Network accessible package and source repositories

Cookbook Dependencies
------------
- runit
- git
- cron

Platform Support
----------------
The following platforms have been tested:

```
|----------------+--------+---------|
|                | poller | alerter |
|----------------+--------+---------|
| Raspbian 7     |   X    |         |
|----------------+--------+---------|
| ubuntu-14.04   |        |    X    |
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
    <td><tt>nil</tt></td>
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
    <td><tt>['snekmon']['graphite_address']</tt></td>
    <td>ipv4 address or hostname</td>
    <td>For chef solo users or those who don't want to rely on search to find the graphite server in your chef organization you can use this attribute.</td>
    <td><tt>nil</tt></td>
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
    <td>percentage of %100</td>
    <td>This probe I put in the humid hide in the center of the vivariumr.  For my corn snake %40+ humidity is sufficient for healthy shedding but with the humid hide I can offer higher humidity in a localized area in the viv the snake can use as he wants.</td>
    <td><tt>39</tt></td>
  </tr>
</table>

Usage
-----
#### snekmon::default
This recipe does nothing, do not use it.  It is a trick to hopefully be mindful that you need to choose a specific recipe and know the intent of each one.

#### snekmon::poller
For me this runs on a raspberry pi B+ running raspbian 7 with the 3 USB temp/humidity probes connected to it.

#### snekmon::alerting
This can run anywhere in your environment that can talk to your graphite server.  I run this right on the graphite server myself.  This probably could run on the raspberry pi but I prefer to be very careful about not putting too much load on it.

In addition to putting the poller and/or alerting recipe on a node there probably are some other attributes you will want to overrite (see: attributes for the rest):
```json
{
  "override_attributes": {
    "snekmon": {
      "graphite_userurl": "https://grafana.example.com",
      "graphite_address": "graphite.example.com",
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
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

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
