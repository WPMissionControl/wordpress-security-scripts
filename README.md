# 🛡️ WordPress Security & Hardening Scripts

A curated set of CLI and WP-CLI scripts to scan, clean, and harden WordPress sites — built for developers, sysadmins, and care plan providers.

These are the same scripts used and maintained by the team behind [WPMissionControl](https://wpmissioncontrol.com), a platform for 24/7 WordPress uptime and security monitoring.

---

## 🧪 Scan Scripts

Located in `scan/`:

- `scan-recent-modified-files.sh` – find recently changed files
- `scan-db-for-redirects.sh` – look for suspicious links in post content
- `scan-suspicious-functions.sh` – search for `eval`, `base64_decode`, `shell_exec`, etc.
- `scan-uploads-for-php.sh` – detect executable files in the `uploads/` folder

---

## 🔐 Hardening Scripts

Located in `harden/`:

- `fix-permissions.sh` – reset file and folder permissions to recommended values
- `remove-unused-themes.sh` – delete all inactive themes
- `disable-file-editing.sh` – prevent admin-based code editing
- `secure-wp-config.sh` – lock down your `wp-config.php` file

---

## 📈 Monitoring Scripts

Located in `monitor/`:

- `enable-debug-log.sh` – enable WP_DEBUG logging
- `wp-profile-scan.sh` – use `wp profile` to detect slow hooks
- `check-cron-jobs.sh` – list all WP-Cron events and flag unknown ones

---

## 🛠 Requirements

- `bash`
- `find`, `grep`, `sed`
- `wp-cli`
- SSH or filesystem access to your WordPress installation

---

## 📦 Usage Example

```bash
bash scan/scan-recent-modified-files.sh /var/www/html/
wp option get siteurl
bash harden/fix-permissions.sh /var/www/html/

---

## 📡 Maintained by

These scripts are maintained by the team at [WPMissionControl](https://wpmissioncontrol.com) — a platform offering WordPress uptime checks, file integrity monitoring, SSL expiration alerts, domain expiration monitoring, and downloadable client reports.

---

## ⚠️ Disclaimer

These scripts are intended for developers and sysadmins. Always back up your site before running any of them. Use at your own risk.

---

## 📄 License

Licensed under the [MIT License](https://opensource.org/licenses/MIT).
