{ config, pkgs, ... }:
{
  systemd.services.backup-to-external = {
    script = ''
      set -e
      mkdir -p /var/backups

      # postgres peer auth requires connecting as the postgres OS user, not root
      ${pkgs.util-linux}/bin/runuser -u postgres -- \
        ${pkgs.postgresql}/bin/pg_dumpall > /var/backups/postgres-all.sql

      ${pkgs.mariadb}/bin/mysqldump --all-databases > /var/backups/mysql-all.sql

      export RESTIC_REPOSITORY=/mnt/backup/restic-repo
      export RESTIC_PASSWORD_FILE=/etc/restic-backup-password

      ${pkgs.restic}/bin/restic backup \
        /var/backups \
        /srv/http \
        /var/lib/cloudflare-tunnels \
        /etc/nixos \
        /root/.config/sops/age \
        /var/lib/tor

      ${pkgs.restic}/bin/restic forget --keep-daily 7 --keep-weekly 4 --prune
    '';
    serviceConfig = {
      Type = "oneshot";
      User = "root";
    };
  };

  systemd.timers.backup-to-external = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "daily";
      Persistent = true;
    };
  };
}
