# AppScale Datastore Image for FoundationDB backend

Image for running AppScale Datastores on AWS with a FoundationDB backend.

Configuration from the host should be mapped as volumes:

* /etc/appscale
* /etc/foundationdb

or otherwise provided to the image.

Systemd can be used to run service instances. An example for running with
port 4000 is:

```
# systemctl start appscale-datastore@4000.service
# systemctl enable appscale-datastore@4000.service
```

A groomer can be run to write statistics periodically:

```
# systemctl start appscale-datastore-groomer.service appscale-datastore-groomer.timer
# systemctl enable appscale-datastore-groomer.service appscale-datastore-groomer.timer
```

Logs can be viewed via the journal:

```
# journalctl -fu appscale-datastore@*.service
-- Logs begin at Mon 2019-07-29 00:27:10 UTC. --
Jul 29 00:33:30 ip-10-4-143-40 datastore-4001[9523]: 2019-07-29 00:33:30,693 INFO connection.py:637 Connecting to 127.0.0.1:2181, use_ssl: False
```

List timer schedule with:

```
# systemctl list-timers appscale-datastore-groomer.timer
NEXT                         LEFT         LAST PASSED UNIT                             ACTIVATES
Mon 2019-07-29 01:41:55 UTC  1h 9min left n/a  n/a    appscale-datastore-groomer.timer appscale-datastore-groomer.service
```
