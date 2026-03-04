{
  config,
  pkgs,
  username,
  hostname,
  ...
}:

{
  systemd.tmpfiles.rules = [
    "d /var/lib/postgresql/logs 0750 postgres postgres -"
  ];
  services.postgresql = {
    enable = true;
    package = pkgs.unstable.postgresql_18;
    extraPlugins = ps: [ ps.pgtap ];
    ensureDatabases = [ "pgFirstAid" ];
    enableTCPIP = true;
    settings = {
      listen_addresses = "*";
      cluster_name = "${hostname}/randoneering";
      ssl = true;
      ssl_ca_file = "/mnt/postgres/root.crt";
      ssl_cert_file = "/mnt/postgres/server.crt";
      ssl_key_file = "/mnt/postgres/server.key";
      password_encryption = "scram-sha-256";

      ## Logging ##
      log_destination = "stderr";
      logging_collector = "on";
      log_filename = "postgresql-%Y-%m-%d_%H%M%S.log";
      log_rotation_age = "7d";
      log_rotation_size = "100MB";
      log_directory = "/var/lib/postgresql/logs";
      log_hostname = "on";
      log_line_prefix = "%m [%p] %q%u@%d";
      log_lock_waits = "on";
      log_recovery_conflict_waits = "on";
      log_statement = "ddl";
      log_timezone = "Etc/UTC";

      ### When To Log ####
      log_min_messages = "warning";
      log_min_error_statement = "error";
      log_connections = "on";
      log_disconnections = "on";

      ## Resource Usage ##
      shared_buffers = "128MB";
      maintenance_work_mem = "64MB";
      autovacuum_work_mem = -1;
      dynamic_shared_memory_type = "posix";
      min_dynamic_shared_memory = "0MB";
      vacuum_buffer_usage_limit = "256kB";

      ## WAL Settings ##
      max_wal_size = "1GB";
      min_wal_size = "80MB";

      ## Stats ##
      track_activities = "on";
      track_activity_query_size = "1024";
      track_counts = "on";
      track_io_timing = "on";
      track_functions = "pl";
      stats_fetch_consistency = "cache";
      compute_query_id = "auto";
      #log_statement_stats = "off";
      #log_parser_stats = "off";
      #log_planner_stats = "off";
      #log_executor_stats = "off";

      ## Autovacuum ##
      autovacuum = "on";
      autovacuum_max_workers = "2";
      autovacuum_vacuum_threshold = "1000";
      autovacuum_vacuum_insert_threshold = "1000";
      autovacuum_analyze_threshold = "1000";
      autovacuum_vacuum_scale_factor = "0.2";
      autovacuum_vacuum_insert_scale_factor = "0.2";
      autovacuum_analyze_scale_factor = "0.1";

      ## Client Connection Defaults ##
      client_min_messages = "notice";
      datestyle = "iso, mdy";
      timezone = "Etc/UTC";
      default_text_search_config = "pg_catalog.english";
    };
    port = 5432;
    authentication = pkgs.lib.mkOverride 10 ''
      # type database DBuser origin-address auth-method
      local    all     all     trust
      # ipv4
      host     all     all    10.10.1.0/24 scram-sha-256
      hostssl  all     all    10.10.1.0/24 scram-sha-256
      # ipv6
      host     all     all    ::1/128      scram-sha-256
    '';
  };

}
