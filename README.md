# SonarQube Home Manager Module

[![Home Manager](https://img.shields.io/badge/Home_Manager_Module-5277C3.svg?logo=nixos)](https://github.com/nix-community/home-manager)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A Home Manager module for running SonarQube locally with Nix-powered dependency management.

## Features

- 🏠 **Home Manager integration** - No root access required
- ⚡ **User-level service** - Runs under your user account
- 🔧 **Pre-configured defaults** - Works out-of-the-box
- 📦 **Self-contained** - Bundles correct JDK version

## Installation

### Add to your Home Manager flake inputs:
```nix
{
  inputs = {
    sonarqube.url = "github:cirius-nix/sonarqube";
  };
}
```

### Import the module in your Home Manager configuration:
```nix
{ inputs, ... }: {
  imports = [ inputs.sonarqube.homeModules.sonarqube ];
}
```

### Enable SonarQube service or set shell aliases in home module:

See example [here](https://github.com/cirius-nix/cirius-nix/blob/master/modules/home/development/infra/sonarqube/default.nix).

```nix
{
  options = {};

  config = {
    # ...
    sonarqube.services.sonarqube = {
      enable = true;
      jdk = pkgs.jdk17_headless;
      stateDir = "${user.homeDir}/.local/state/sonarqube";
      autoStart = false;
      fishIntegration = {
        enable = fish.enable;
        alias = "sq";
      };
    };
  };
}
```

In this config:

***Persistence Paths***

```text
~/.local/state/sonarqube/
├── data/     # H2 database (default)
├── logs/     # SonarQube logs
└── temp/     # JVM temp files
```

***Security Considerations***

    Firewall: The service binds to 127.0.0.1 by default

    Memory Limits: JVM heap size capped at 1GB in defaults

    User Isolation: Runs under your user account only

To expose to local network, set these variables under os configuration:
```nix
{
  services.sonarqube.listenAddress = "0.0.0.0";
  networking.firewall.allowedTCPPorts = [ 9000 ];
}
```

If `autoStart` is not enabled, you can manually control `sonarqube` by shell alias: `sq`

```fish
sq
# Usage: /nix/store/.../sonar.sh { console | start | stop | force-stop | restart | status | dump }
```

### Full options is defined at [here](https://github.com/cirius-nix/sonarqube/blob/main/packages/sonarqube/default.nix)
