# Automated Linux Monitoring System

A lightweight Bash-based monitoring agent designed to collect host-level system metrics.

Project Evolution (Active Development):
While this project started as a purely Bash-based automation tool, it is currently being refactored into a full-stack, cloud-native monitoring solution. This initiative is part of my effort to bridge the gap between low-level system infrastructure and modern backend development.

Roadmap (In Progress)
[x] Phase 1: Foundation (Completed)

Bash-based metric collection (CPU, Memory, Disk).

Structured logging and threshold-based alerting.

Containerization with Docker (host namespace access).

[ ] Phase 2: Backend Development (In Progress)

Building a C# (ASP.NET Core) REST API to parse and serve system logs as JSON.

Implementing SQL database integration for historical metrics analysis.

[ ] Phase 3: Infrastructure as Code & Cloud (Planned)

Infrastructure provisioning using Terraform (IaC).

Automated deployment with CI/CD pipelines.

Cloud-native deployment on Google Cloud Platform (GCP).

---

## Overview

By default, containers are isolated and cannot access host system metrics. This project shows how to:

* Access host-level metrics from within a container
* Use Linux virtual filesystems such as `/proc` and `/sys`
* Build a simple and effective monitoring solution using Bash

---

## Features

* Automatic log management

  * Creates a `logs/` directory if it does not exist
  * Generates timestamped log files

* Host system monitoring

  * CPU load average via `/proc/loadavg`
  * Memory usage calculated from `/proc/meminfo`
  * Disk usage via `df -h` on the host filesystem

* Timestamped logging

  * Each log entry includes a precise timestamp

* Disk usage alert

  * Triggers a warning if usage exceeds 80%

---

## Running with Docker

### Build the image

```bash
docker build -t automated-monitoring-image .
```

### Run the container (host monitoring mode)

```bash
docker run -it \
  --pid=host \
  -v /proc:/host/proc:ro \
  -v /sys:/host/sys:ro \
  -v /:/host/root:ro \
  automated-monitoring-image
```

---

## How It Works

* `--pid=host` allows access to host process and `/proc` information
* `/host/proc` provides access to host runtime metrics (memory, load)
* `/host/sys` exposes kernel and hardware-related information
* `/host/root` provides access to the host filesystem for disk monitoring

Inside the container:

* `/host/proc` → host metrics
* `/host/sys` → kernel/system interface
* `/host/root` → host filesystem

---

## Running Without Docker

```bash
chmod +x monitor.sh
./monitor.sh
```

Ensure the script path matches:

```bash
~/github/automated-linux-monitoring-system/
```

---

## Automation with Cron

To run the script every 5 minutes:

```bash
crontab -e
```

Add the following:

```cron
*/5 * * * * /bin/bash $HOME/github/automated-linux-monitoring-system/monitor.sh
```

---

## Example Log Output

```text
============================'Server average load'=========================
[2026-04-15 12 00 01] 0.15 0.10 0.05 1/200 12345

============================Memory usage=========================
[2026-04-15 12 00 01] The memory usage is 37%

============================'Disk usage'=========================
[2026-04-15 12 00 01] Filesystem      Size  Used Avail Use% Mounted on
[2026-04-15 12 00 01] /dev/sda1        50G   20G   30G  40% /
```

---

## Notes

* The script reads host metrics through mounted paths such as `/host/proc` and `/host/sys`
* Disk monitoring is performed using `/host/root`
* Avoid hardcoding device names such as `/dev/sda2`; use mount points instead

---

## Future Improvements

* Continuous monitoring loop (daemon mode)
* Alerting via external systems (email, webhooks)
* Export metrics for Prometheus integration

---

## Conclusion

This project demonstrates practical understanding of:

* Linux
* Docker
* Host-level monitoring design patterns

It serves as a foundation for building more advanced monitoring and observability tools.
