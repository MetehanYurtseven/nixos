{
  config,
  ...
}:
{
  services.restic.backups."default" = {
    user = "root";
    initialize = true;
    runCheck = true;
    timerConfig = {
      OnCalendar = "daily";
      Persistent = true;
    };
    extraBackupArgs = [
      "--exclude-caches"
      "--one-file-system"
    ];
    pruneOpts = [
      "--keep-daily 7"
      "--keep-weekly 4"
      "--keep-monthly 12"
      "--keep-yearly 3"
    ];
    exclude = [
      "/home/*/.cache"
      "/home/*/.local/share/Trash"
      "**/__pycache__"
      "**/node_modules"
      "/home/*/.mozilla/firefox/*/storage"
      "/home/*/.config/chromium/Default/Cache"
    ];
    repositoryFile = config.sops.secrets."restic/repository".path;
    passwordFile = config.sops.secrets."restic/key".path;
    paths = [ "/home" ];
  };
}
