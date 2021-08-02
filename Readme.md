# Bolt Torque

A super-simple templated Torque Pro dashboard generator script for use with the original Bolt EV custom PIDs for Chevy Bolt as well as Opel Ampera-e.

## Description

The `bash` script creates a custom Torque Pro compliant dashboard file that can be imported via `Layout Settings` --> `Import Layout` from the `.torque/dashboards` folder on your Android device. Variables, like for instance the devices screen dimensions can be customized and are used to distribute the individual displays.

## Getting Started

### Dependencies

* Bourne Again Shell (bash)

### Installing

* Simply download the script plus template files and place them in a folder on your computer.

### Executing program

* Load the script into a text editor and tweak parameters (optional)
* Run the following command
```
> ./generate-da.sh > Bolt-EV.dash
```
* Transfer the `Bolt-EV.dash` file (or whatever you choose to name it) to the dashboard folder (i.e., `.torque/dashboards`) on your Android device.
* Access `Layout Settings` from the gear symbol on the lower left corner of the dashboard screen and pick `Import Layout`.

## Help

* Please let me know if you should encounter any issues.

## Version History

* 0.1
    * Initial Release

## License

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

