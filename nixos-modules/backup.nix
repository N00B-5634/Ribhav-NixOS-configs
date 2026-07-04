{ config, pkgs, ... }:
{
  systemd.services.backup-to-external = {
    script = ''
      set -e
      mkdir -p /var/backups
      ${pkgs.postgresql}/bin/pg_dumpall > /var/backups/postgres-all.sql
      ${pkgs.mariadb}/bin/mysqldump --all-databases > /var/backups/mysql-all.sql

      export RESTIC_REPOSITORY=/mnt/backup/restic-repo
      export RESTIC_PASSWORD_FILE=/etc/restic-backup-password

      ${pkgs.restic}/bin/restic backup \
        /var/backups \
        /srv/http \
        /etc/keycloak-db-pass \
        /var/lib/cloudflare-tunnels

      ${pkgs.restic}/bin/restic forget --keep-daily 7 --keep-weekly 4 --prune
    '';
    serviceConfig = {
      Type = "oneshot";
      User = "root";  # needs to read /etc secrets and dump DBs
    };
  };

  systemd.timers.backup-to-external = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "daily";
      Persistent = true;  # runs on next boot if the machine was off at the scheduled time
    };
  };
}
