Lantiq DSL Statistics
=====================

Configuration and scripts to collect and plot DSL line statistics in OpenWrt
with LuCI using collectd and rrdtool.

OpenWrt provides the `/etc/init.d/dsl_control` script to query the current DSL
parameters. With the scripts and configuration described below, one can
collect and plot the values, e.g., in order to analyze stability issues.

If you are unfamiliar with OpenWrt/LuCI's statistics support, check the
[OpenWrt wiki page on luci-app-statistics](https://openwrt.org/docs/guide-user/luci/luci_app_statistics).
The following guide assumes, that you have statistics basically setup
and the package `luci-app-statistics` installed.

Furthermore, this setup was tested with the rrdtool support from the package
`collectd-mod-rrdtool` which was configured to write to a USB drive in order to
avoid flash wear. Check the
[OpenWrt wiki page about how to add a USB drive](https://openwrt.org/docs/guide-user/storage/usb-drives-quickstart)
for details.


Data Collection
---------------

Setup data collection:

0. Install packages: collectd-mod-exec shadow-useradd sudo
1. Copy the `collect-dsl` script into `/usr/sbin/` and make it executable.
2. Add a new user to run `collect-dsl` as:
   `useradd -r -s /bin/false -d /var collector`
3. Copy `sudoers` into the new file `/etc/sudoers.d/collector` to allow
   execution of `collect-dsl` with privileges.
4. Configure collectd's exec module to execute the command
   `/usr/bin/sudo -E /usr/sbin/collect-dsl`
   with user `collector` and group `collector`.

This should be enough to get the data collected. Rrdtool's storage directory
should now contain a `dsl-dsl0/` directory with several .rrd files.
Rrdtool provides [commands to check the contents of .rrd files](https://oss.oetiker.ch/rrdtool/doc/rrdtool.en.html).

Some useful links for development:

* [OpenWrt wiki page about the exec module](https://openwrt.org/docs/guide-user/perf_and_log/statistic.custom)
* [Manpage of collectd's exec module](https://collectd.org/documentation/manpages/collectd-exec.5.shtml)
* [Explanation of data sources/types in collectd](https://collectd.org/wiki/index.php/Data_source)
* File `/usr/share/collectd/types.db` with actual data type definitions.

Plotting
--------

Plotting is based on the package `luci-app-statistics`.

To plot the collected data in LuCI simply copy `dsl.lua` into
`/usr/lib/lua/luci/statistics/rrdtool/definitions/`.

After refreshing the graph page, it should show a "DSL" tab with many plots of
signal strengths, data rates, and transmission errors.

If you want to change the plot appearence, do not forget to delete
`/tmp/luci-indexcache` and `/tmp/luci-modulecache/` before refreshing.
