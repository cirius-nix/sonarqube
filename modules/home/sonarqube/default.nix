{
  config,
  pkgs,
  namespace,
  lib,
  ...
}:
let
  inherit (lib)
    mkIf
    mkEnableOption
    mkOption
    types
    ;

  inherit ((config.${namespace}.services)) sonarqube;
in
{
  options.${namespace}.services.sonarqube = {
    enable = mkEnableOption "Enable sonarqube service";

    fishIntegration = {
      enable = mkEnableOption "Enable fish shell integration";
      alias = mkOption {
        type = types.str;
        default = "sq";
        description = "Alias";
      };
    };

    bashIntergration = {
      enable = mkEnableOption "Enable bash shell integration";
      useRC = mkEnableOption "Config bashrc";
      alias = mkOption {
        type = types.str;
        default = "sq";
        description = "Alias";
      };
    };

    zshIntegration = {
      enable = mkEnableOption "Enable zsh shell integration";
      alias = mkOption {
        type = types.str;
        default = "sq";
        description = "Alias";
      };
    };

    autoStart = mkEnableOption "auto start";

    package = mkOption {
      type = lib.types.package;
      default = pkgs.${namespace}.sonarqube;
      description = "Sonarqube packages to install";
    };

    jdk = mkOption {
      type = lib.types.package;
      default = pkgs.jdk17_headless;
      description = "JDK package to use";
    };

    stateDir = mkOption {
      type = types.str;
      default = "/var/lib/sonarqube";
      description = "SonarQube state directory";
    };

    jdbc = {
      username = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "Database username";
      };

      password = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "Database password";
      };

      url = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "JDBC connection URL";
      };

      maxActive = mkOption {
        type = types.int;
        default = 60;
        description = "Maximum number of active connections";
      };

      minIdle = mkOption {
        type = types.int;
        default = 10;
        description = "Minimum number of idle connections";
      };

      maxWait = mkOption {
        type = types.int;
        default = 8000;
        description = "Maximum wait time for a connection in milliseconds";
      };
    };

    web = {
      host = mkOption {
        type = types.str;
        default = "0.0.0.0";
        description = "Web server binding address";
      };

      port = mkOption {
        type = types.port;
        default = 9000;
        description = "Web server port";
      };

      context = mkOption {
        type = types.str;
        default = "";
        description = "Web context path";
      };

      javaOpts = mkOption {
        type = types.str;
        default = "-Xmx512m -Xms128m -XX:+HeapDumpOnOutOfMemoryError";
        description = "JVM options for the web server";
      };

      maxThreads = mkOption {
        type = types.int;
        default = 50;
        description = "Maximum number of connections";
      };

      minThreads = mkOption {
        type = types.int;
        default = 5;
        description = "Minimum number of threads";
      };

      acceptCount = mkOption {
        type = types.int;
        default = 25;
        description = "Maximum queue length for incoming connections";
      };

      keepAliveTimeout = mkOption {
        type = types.int;
        default = 60000;
        description = "Keep-alive timeout in milliseconds";
      };

      jwtBase64Hs256Secret = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "JWT secret for session persistence";
      };

      sessionTimeoutInMinutes = mkOption {
        type = types.int;
        default = 4320;
        description = "User session timeout in minutes";
      };

      systemPasscode = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "Passcode for monitoring web services";
      };
    };

    ce = {
      javaOpts = mkOption {
        type = types.str;
        default = "-Xmx512m -Xms128m -XX:+HeapDumpOnOutOfMemoryError";
        description = "JVM options for the compute engine";
      };
    };

    search = {
      javaOpts = mkOption {
        type = types.str;
        default = "-Xmx512m -Xms512m -XX:MaxDirectMemorySize=256m -XX:+HeapDumpOnOutOfMemoryError";
        description = "JVM options for Elasticsearch";
      };

      port = mkOption {
        type = types.port;
        default = 9001;
        description = "Elasticsearch HTTP port";
      };

      host = mkOption {
        type = types.str;
        default = "127.0.0.1";
        description = "Elasticsearch binding address";
      };
    };

    ldap = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Enable LDAP authentication";
      };

      url = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "LDAP server URL";
      };

      bindDn = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "LDAP bind DN";
      };

      bindPassword = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "LDAP bind password";
      };

      user = {
        baseDn = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = "Base DN for user search";
        };

        request = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = "LDAP user search filter";
        };

        realNameAttribute = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = "LDAP attribute for user's real name";
        };

        emailAttribute = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = "LDAP attribute for user's email";
        };
      };

      group = {
        baseDn = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = "Base DN for group search";
        };

        request = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = "LDAP group search filter";
        };
      };
    };

    sso = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Enable SSO authentication";
      };

      loginHeader = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "Header containing user login";
      };

      nameHeader = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "Header containing user name";
      };

      emailHeader = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "Header containing user email";
      };

      groupsHeader = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "Header containing user groups";
      };

      refreshIntervalInMinutes = mkOption {
        type = types.int;
        default = 5;
        description = "Refresh interval for SSO attributes";
      };
    };

    updateCenter = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Enable update center";
      };
    };

    telemetry = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Enable telemetry";
      };
    };

    logging = {
      level = mkOption {
        type = types.enum [
          "INFO"
          "DEBUG"
          "TRACE"
        ];
        default = "INFO";
        description = "Global log level";
      };

      accessLogs = {
        enable = mkOption {
          type = types.bool;
          default = true;
          description = "Enable access logs";
        };

        pattern = mkOption {
          type = types.str;
          default = "%h %l %u [%t] \"%r\" %s %b \"%i{Referer}\" \"%i{User-Agent}\" \"%reqAttribute{ID}\" %D";
          description = "Access log pattern";
        };
      };
    };
  };

  config = mkIf sonarqube.enable {
    home.packages = [
      pkgs.sonarlint-ls
      pkgs.sonar-scanner-cli
    ];

    programs.zsh = mkIf sonarqube.zshIntegration.enable {
      initContent = ''
        function ${sonarqube.zshIntegration.alias}() {
          export SONAR_HOME=${sonarqube.package}
          export SONAR_PATH_DATA="${sonarqube.stateDir}/data"
          export SONAR_PATH_LOGS="${sonarqube.stateDir}/logs"
          export SONAR_PATH_TEMP="${sonarqube.stateDir}/temp"
          export SONAR_JAVA_PATH="${sonarqube.jdk}/bin/java"
          export PIDDIR=${sonarqube.stateDir}
          export NOHUPDIR="${sonarqube.stateDir}/logs"

          ${sonarqube.package}/bin/${
            if pkgs.stdenv.isLinux then "linux-x86-64" else "macosx-universal-64"
          }/sonar.sh "$@"
        }
      '';
    };

    programs.bash = mkIf sonarqube.bashIntegration.enable (
      let
        handler = ''
          # sonarqube wrapper
          function ${sonarqube.bashIntegration.alias}() {
            export SONAR_HOME=${sonarqube.package}
            export SONAR_PATH_DATA="${sonarqube.stateDir}/data"
            export SONAR_PATH_LOGS="${sonarqube.stateDir}/logs"
            export SONAR_PATH_TEMP="${sonarqube.stateDir}/temp"
            export SONAR_JAVA_PATH="${sonarqube.jdk}/bin/java"
            export PIDDIR=${sonarqube.stateDir}
            export NOHUPDIR="${sonarqube.stateDir}/logs"

            ${sonarqube.package}/bin/${
              if pkgs.stdenv.isLinux then "linux-x86-64" else "macosx-universal-64"
            }/sonar.sh "$@"
          }
        '';
      in
      {
        initExtra = ''${handler}'';
        bashrcExtra = mkIf sonarqube.bashIntegration.useRC ''${handler}'';
      }
    );

    programs.fish = mkIf sonarqube.fishIntegration.enable {
      interactiveShellInit = ''
        # sonarqube wrapper
        function ${sonarqube.fishIntegration.alias}
          set -x SONAR_HOME ${sonarqube.package}
          set -x SONAR_PATH_DATA "${sonarqube.stateDir}/data"
          set -x SONAR_PATH_LOGS "${sonarqube.stateDir}/logs"
          set -x SONAR_PATH_TEMP "${sonarqube.stateDir}/temp"
          set -x SONAR_JAVA_PATH "${sonarqube.jdk}/bin/java"
          set -x PIDDIR ${sonarqube.stateDir}
          set -x NOHUPDIR "${sonarqube.stateDir}/logs"

          ${sonarqube.package}/bin/${
            if pkgs.stdenv.isLinux then "linux-x86-64" else "macosx-universal-64"
          }/sonar.sh $argv
        end
      '';
    };

    systemd.user.services.sonarqube = mkIf pkgs.stdenv.isLinux {
      Unit = {
        Description = "SonarQube service";
        After = [
          "network.target"
          "syslog.target"
        ];
      };

      Service = {
        ExecStart = "${sonarqube.package}/bin/linux-x86-64/sonar.sh start";
        ExecStop = "${sonarqube.package}/bin/linux-x86-64/sonar.sh stop";
        Restart = "on-failure";
        TimeoutStartSec = 5;
        Environment = [
          "SONAR_HOME=${sonarqube.package}"
          "SONAR_PATH_DATA=${sonarqube.stateDir}/data"
          "SONAR_PATH_LOGS=${sonarqube.stateDir}/logs"
          "SONAR_PATH_TEMP=${sonarqube.stateDir}/temp"
          "SONAR_JAVA_PATH=${sonarqube.jdk}/bin/java"
          "PIDDIR=${sonarqube.stateDir}"
          "NOHUPDIR=${sonarqube.stateDir}/logs"
        ];
        LimitNOFILE = 131072;
        LimitNPROC = 8192;
      };

      Install = mkIf sonarqube.autoStart {
        WantedBy = [ "default.target" ];
      };
    };

    launchd.agents.sonarqube = mkIf pkgs.stdenv.isDarwin {
      enable = true;
      config = {
        Label = "dev.sonarqube";
        ProgramArguments = [
          "${sonarqube.package}/bin/macosx-universal-64/sonar.sh"
          "start"
        ];
        RunAtLoad = sonarqube.autoStart;
        KeepAlive = sonarqube.autoStart;
        EnvironmentVariables = {
          SONAR_HOME = "${sonarqube.package}";
          SONAR_PATH_DATA = "${sonarqube.stateDir}/data";
          SONAR_PATH_LOGS = "${sonarqube.stateDir}/logs";
          SONAR_PATH_TEMP = "${sonarqube.stateDir}/temp";
          SONAR_JAVA_PATH = "${sonarqube.jdk}/bin/java";
          PIDDIR = "${sonarqube.stateDir}";
          NOHUPDIR = "${sonarqube.stateDir}/logs";
        };
        StandardOutPath = "${sonarqube.stateDir}/logs/sonarqube.out.log";
        StandardErrorPath = "${sonarqube.stateDir}/logs/sonarqube.err.log";
      };

    };

    home.file.".config/sonarqube/conf/sonar.properties".text = lib.concatStringsSep "\n" (
      (lib.optional (sonarqube.jdbc.username != null) "sonar.jdbc.username=${sonarqube.jdbc.username}")
      ++ (lib.optional (sonarqube.jdbc.password != null) "sonar.jdbc.password=${sonarqube.jdbc.password}")
      ++ (lib.optional (sonarqube.jdbc.url != null) "sonar.jdbc.url=${sonarqube.jdbc.url}")
      ++ [
        "sonar.jdbc.maxActive=${toString sonarqube.jdbc.maxActive}"
        "sonar.jdbc.minIdle=${toString sonarqube.jdbc.minIdle}"
        "sonar.jdbc.maxWait=${toString sonarqube.jdbc.maxWait}"
        "sonar.web.host=${sonarqube.web.host}"
        "sonar.web.port=${toString sonarqube.web.port}"
        "sonar.web.context=${sonarqube.web.context}"
        "sonar.web.javaOpts=${sonarqube.web.javaOpts}"
        "sonar.web.http.maxThreads=${toString sonarqube.web.maxThreads}"
        "sonar.web.http.minThreads=${toString sonarqube.web.minThreads}"
        "sonar.web.http.acceptCount=${toString sonarqube.web.acceptCount}"
        "sonar.web.http.keepAliveTimeout=${toString sonarqube.web.keepAliveTimeout}"
        "sonar.web.sessionTimeoutInMinutes=${toString sonarqube.web.sessionTimeoutInMinutes}"
        "sonar.ce.javaOpts=${sonarqube.ce.javaOpts}"
        "sonar.search.javaOpts=${sonarqube.search.javaOpts}"
        "sonar.search.port=${toString sonarqube.search.port}"
        "sonar.search.host=${sonarqube.search.host}"
        "sonar.updatecenter.activate=${lib.boolToString sonarqube.updateCenter.enable}"
        "sonar.telemetry.enable=${lib.boolToString sonarqube.telemetry.enable}"
        "sonar.log.level=${sonarqube.logging.level}"
        "sonar.web.accessLogs.enable=${lib.boolToString sonarqube.logging.accessLogs.enable}"
        "sonar.web.accessLogs.pattern=${sonarqube.logging.accessLogs.pattern}"
      ]
      ++ (lib.optional (
        sonarqube.web.jwtBase64Hs256Secret != null
      ) "sonar.auth.jwtBase64Hs256Secret=${sonarqube.web.jwtBase64Hs256Secret}")
      ++ (lib.optional (
        sonarqube.web.systemPasscode != null
      ) "sonar.web.systemPasscode=${sonarqube.web.systemPasscode}")
      ++ (lib.optional sonarqube.ldap.enable "sonar.security.realm=LDAP")
      ++ (lib.optional (sonarqube.ldap.url != null) "ldap.url=${sonarqube.ldap.url}")
      ++ (lib.optional (sonarqube.ldap.bindDn != null) "ldap.bindDn=${sonarqube.ldap.bindDn}")
      ++ (lib.optional (
        sonarqube.ldap.bindPassword != null
      ) "ldap.bindPassword=${sonarqube.ldap.bindPassword}")
      ++ (lib.optional (
        sonarqube.ldap.user.baseDn != null
      ) "ldap.user.baseDn=${sonarqube.ldap.user.baseDn}")
      ++ (lib.optional (
        sonarqube.ldap.user.request != null
      ) "ldap.user.request=${sonarqube.ldap.user.request}")
      ++ (lib.optional (
        sonarqube.ldap.user.realNameAttribute != null
      ) "ldap.user.realNameAttribute=${sonarqube.ldap.user.realNameAttribute}")
      ++ (lib.optional (
        sonarqube.ldap.user.emailAttribute != null
      ) "ldap.user.emailAttribute=${sonarqube.ldap.user.emailAttribute}")
      ++ (lib.optional (
        sonarqube.ldap.group.baseDn != null
      ) "ldap.group.baseDn=${sonarqube.ldap.group.baseDn}")
      ++ (lib.optional (
        sonarqube.ldap.group.request != null
      ) "ldap.group.request=${sonarqube.ldap.group.request}")
      ++ (lib.optional sonarqube.sso.enable "sonar.web.sso.enable=true")
      ++ (lib.optional (
        sonarqube.sso.loginHeader != null
      ) "sonar.web.sso.loginHeader=${sonarqube.sso.loginHeader}")
      ++ (lib.optional (
        sonarqube.sso.nameHeader != null
      ) "sonar.web.sso.nameHeader=${sonarqube.sso.nameHeader}")
      ++ (lib.optional (
        sonarqube.sso.emailHeader != null
      ) "sonar.web.sso.emailHeader=${sonarqube.sso.emailHeader}")
      ++ (lib.optional (
        sonarqube.sso.groupsHeader != null
      ) "sonar.web.sso.groupsHeader=${sonarqube.sso.groupsHeader}")
      ++ [ "sonar.web.sso.refreshIntervalInMinutes=${toString sonarqube.sso.refreshIntervalInMinutes}" ]
    );

    home.activation.setupSonarQube = config.lib.dag.entryAfter [ "writeBoundary" ] ''
      mkdir -p "${sonarqube.stateDir}"/{data,logs,temp}
      chmod -R u+rwX "${sonarqube.stateDir}"
    '';
  };
}
