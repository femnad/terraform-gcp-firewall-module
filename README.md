# terraform-gcp-firewall-module

A module for lazy GCP firewall rule creation via Terraform.

## Required Input Variables


* `project`: A GCP project to use

* `network`: The network for which to add the rule(s)

## Optional Input Variables

* `self_reachable`: A mapping of ports to protocol which should be reachable from the host running terraform; e.g.:

```
self_reachable = {
  "80,443" = "tcp"
}
```

* `world_reachable`: A mapping of ports to protocol which should be reachable from everywhere

```
world_reachable = {
  "80,443" = "tcp"
}
```

* `ip_mask`: A mask for deriving a prefix of allowed IPs from your public IP. Default is 32, so it only your public IP will be allowed. <sup>[Why?](#why-ip_mask-and-ip_num)</sup>

* `ip_num`: Number of IPs to allow based on the prefix. Default is 1, so only your public IP will be allowed. Needs to agree with `ip_mask`, as in the requested number of IP should be available in the prefix.<sup>[Why?](#why-ip_mask-and-ip_num)</sup>

## Why `ip_mask` and `ip_num`?

This module uses your public IP to determine allowed source ranges for the `self_reachable` mapping. If you're on a connection which results in having multiple public IPs then may want to give a slightly bigger range than a `/32`. In order to that based on the public IP, `ip_mask` and `ip_num` are utilized to derive multiple public IPs.

### Example:

* Your public IP is 10.11.12.13
* `ip_mask` is 29
* `ip_num` is 7

Which gives out 7 IPs, in the form of:

```
10.11.12.8
10.11.12.9
10.11.12.10
10.11.12.11
10.11.12.12
10.11.12.13
10.11.12.14
```
