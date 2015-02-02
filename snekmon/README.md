Snekmon Cookbook
===========================
The Snek Cookbook is for a very specific application where a raspberry pi B+ (4 usb ports required!) has a USB wifi module, 2 USB temp probes, and a USB combo humidity/temp probe to collect metrics and send them to a graphite server.  The poller runs on the raspberry pi, but as I don't see the rpi as a reliable place for long term storage the graphite server is run on virtual machine elsewhere on the lan.

3 temperature probes can be placed with one at the "hot side", "center", "cool side" and as the metrics go into our time series database we can get graphs for different periods of time quickly to visualize the temperature gradient that is vital to the care of reptiles.  I want to be able to have multiple years of data at 1 minute resolution and be more aware of things like seasonal variations in temperature.

Aside from visualization we also want to get smartphone push alerts via prowlapp.com if the averate temps and humidity over the last hour are outside acceptable ranges.

Requirements
------------
TODO: List your cookbook requirements. Be sure to include any requirements this cookbook has on platforms, libraries, other cookbooks, packages, operating systems, etc.

- Raspberry Pi B+ (runs poller)
- 2x TEMPer1V1.4 modules (Microdia is manufacturer per lsusb)
- 1x TEMPERHUM1v1.0 module (also Microdia)
- External Graphite Server (can run alerter)
- http://prowlapp.com account with an API key
- Network accessible package repositories

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
TODO: List your cookbook attributes here.

e.g.
#### snekmon::default
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['snekmon']['bacon']</tt></td>
    <td>Boolean</td>
    <td>whether to include bacon</td>
    <td><tt>true</tt></td>
  </tr>
</table>

Usage
-----
#### snekmon::default
TODO: Write usage instructions for each cookbook.

e.g.
Just include `snekmon` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[snekmon]"
  ]
}
```

Contributing
------------
TODO: (optional) If this is a public cookbook, detail the process for contributing. If this is a private cookbook, remove this section.

e.g.
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
