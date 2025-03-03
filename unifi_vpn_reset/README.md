# Unifi VPN Reset Script

**Works on:** Ubiquiti Dream Machine Pro

This script checks whether the local IP address in a VPN site-to-site on a Unifi Dream Machine Pro is incorrect and updates the configuration files with the correct external IP address.
IPSec service is restarted if necessary.

This should help overcoming a limitation on UDM during ISP reconnects, where the external IP address changes, but the VPN configuration doesn't.

## Installation Instructions

1. **Download the Script**

   Download the `unifi_vpn_reset.sh` script to your desired location. For example:
   ```bash
   wget -O /usr/local/bin/unifi_vpn_reset.sh https://github.com/renato-yuzup/unifi-scripts/unifi_vpn_reset.sh
   ```

2. **Make the Script Executable**

   Ensure the script has executable permissions:
   ```bash
   chmod +x /usr/local/bin/unifi_vpn_reset.sh
   ```

3. **Create a Scheduled Task**

   To run the script every 2 minutes, create a cron job. Open the crontab editor:
   ```bash
   crontab -e
   ```

   Add the following line to the crontab file:
   ```bash
   */2 * * * * /usr/local/bin/unifi_vpn_reset.sh
   ```

   This will schedule the script to run every 2 minutes.

4. **Verify the Cron Job**

   To verify that the cron job has been added, you can list the current cron jobs:
   ```bash
   crontab -l
   ```

   You should see the entry you added:
   ```bash
   */2 * * * * /usr/local/bin/unifi_vpn_reset.sh
   ```

## Logging

The script logs its actions using the `logger` command with the tag `unifi_vpn_reset`. You can view the logs using:
```bash
tail -f /var/log/syslog | grep unifi_vpn_reset
```

## Date

2025-02-05