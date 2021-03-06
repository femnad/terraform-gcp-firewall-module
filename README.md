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
self_reachable = {
  "80,443" = "tcp"
}
```
