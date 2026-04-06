# Automated Linux Monitoring System

A lightweight, automated Bash script designed to monitor essential Linux server metrics. This tool captures system health data and logs it into timestamped files for easy auditing and troubleshooting.

## Features

* **Automated Log Management:** Automatically creates a `logs/` directory and generates unique, timestamped files (e.g., `20260406_2100.log`).
* **Real-Time Metrics:** Logs server date, uptime, and memory usage (`free -h`).
* **Disk Usage Alerts:** Specifically monitors the `/dev/sda2` partition. If usage exceeds **20%**, a warning is automatically flagged in the log.
* **Timestamped Entries:** Every logged metric includes a precise `[YYYY-MM-DD HH:MM:SS]` timestamp.

## Installation & Setup

1.  **Prepare the directory:**
    Ensure the script is placed in the following path (or update the `BASE_DIR` variable in the script):
    `~/github/automated-linux-monitoring-system/`

2.  **Make the script executable:**
    ```bash
    chmod +x monitor.sh
    ```

3.  **Run manually:**
    ```bash
    ./monitor.sh
    ```

## Automation with Cron

To monitor your server continuously, set the script to run every 5 minutes:

1.  Open your crontab:
    ```bash
    crontab -e
    ```
2.  Add this line at the bottom:
    ```cron
    */5 * * * * /bin/bash $HOME/github/automated-linux-monitoring-system/monitor.sh
    ```

## Log Example

Logs are stored in the `/logs` folder and look like this:

```text
==================='Disk usage'==================
[2026-04-06 21:00:01] Filesystem      Size  Used Avail Use% Mounted on 
[2026-04-06 21:00:01] /dev/sda2        50G   15G   33G  31% / 
[2026-04-06 21:00:01] Warning: the disk usage exceeds 20%

## License

This project is open-source and free to use.
