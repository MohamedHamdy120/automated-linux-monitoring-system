# Automated Linux Monitoring System

A lightweight Bash-based monitoring agent evolving into a full-stack, cloud-native observability platform. This project showcases the transition from simple host-level automation to a scalable architecture that integrates C# backend APIs, database persistence, and automated infrastructure deployment.


## Project Evolution (Active Development)
While this project started as a purely Bash-based automation tool, it is currently being refactored into a full-stack, cloud-native monitoring solution. This initiative is part of my effort to bridge the gap between low-level system infrastructure and modern backend development.

## Roadmap (In Progress)
- [x] **Phase 1: Foundation (Completed)**
  - Bash-based metric collection (CPU, Memory, Disk).
  - Structured logging and threshold-based alerting.
  - Containerization with Docker (host namespace access).

- [ ] **Phase 2: Backend Development (Completed/Active)**
  - Building a C# (ASP.NET Core) REST API to parse and serve system logs as JSON.
  - Implementing SQL database integration for historical metrics analysis.

- [ ] **Phase 3: Infrastructure as Code & Cloud (Planned)**
  - Infrastructure provisioning using Terraform (IaC).
  - Automated deployment with CI/CD pipelines.
  - Cloud-native deployment on Google Cloud Platform (GCP).

## Tech Stack
- **Languages:** Bash, C# (ASP.NET Core - In Progress).
- **Database:** SQL/Relational DB (Planned).
- **DevOps & Infrastructure:** Docker, Terraform, Google Cloud Platform (GCP).
- **Methodology:** DevOps, CI/CD pipelines, RESTful API design.

## Why this project?
This project demonstrates my ability to:
- Automate manual tasks using Linux scripting.
- Design scalable backends using C#.
- Manage infrastructure using Terraform.
- Adopt DevOps best practices throughout the development lifecycle.

---

## Overview of the completed phase 1

By default, containers are isolated and cannot access host system metrics. This project shows how to:

* Access host-level metrics from within a container
* Use Linux virtual filesystems such as `/proc` and `/sys`
* Build a simple and effective monitoring solution using Bash

---

## Overview of the completed phase 2

Developing a .NET Minimal API to serve as a central hub for system metrics. This phase demonstrates how to:

* Create a RESTful API endpoint to accept incoming telemetry data via HTTP POST
* Implement JSON deserialization to process system metrics sent by the monitoring agent
* Decouple the monitoring agent from data processing logic to ensure modularity==
* Establish a structured communication protocol between the Bash agent and the .NET backend

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

* API Metric Ingestion

  * Exposes a RESTful endpoint for real-time telemetry reception
  * Processes JSON payloads via HTTP POST requests
  * Decouples data collection logic from backend processing

---

## Running the Backend API

The Backend API must be running on the host machine to accept incoming data from the monitoring agent.

### Navigate to the API project directory
```bash
cd BackendProjects/LinuxMonitorApi
```

### Start the API
```bash
dotnet run
```

> **Note:**  
> Ensure your application is configured to listen on all interfaces (e.g., `http://0.0.0.0:5125`) instead of just `localhost`, so it can accept connections from the Docker bridge network.

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

## API Connectivity and Docker Networking

The system uses the default Docker bridge network to allow communication between the monitoring agent (inside the container) and the backend API (running on the host).

### Connectivity Details
* **Host Gateway:** The container communicates with the host machine using the Docker bridge gateway IP address.
* **API Endpoint:** The monitoring agent is configured to send HTTP POST requests to:
  `http://172.17.0.1:5125/api/metrics`

*Note: Ensure your API is configured to listen on all interfaces (e.g., `http://0.0.0.0:5125`) rather than just `localhost` so it can accept connections coming from the Docker bridge network.*

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
