# /etc/nixos/nginx-config.nix
{
  # Nginx configuration
  services.nginx = {
    enable = true;
    recommendedGzipSettings = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    virtualHosts = {
      # OpenVPN Web UI
      "vpn-anokxz.duckdns.org" = {
        enableACME = true;
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://localhost:943";  # OpenVPN Web UI port
          proxyWebsockets = true;
        };
      };

      # Jellyfin
      "media-anokxz.duckdns.org" = {
        enableACME = true;
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://localhost:8096";  # Jellyfin port
          proxyWebsockets = true;
        };
      };

      # Nextcloud
      "cloud-anokxz.duckdns.org" = {
        enableACME = true;
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://localhost:8080";  # Nextcloud port
          proxyWebsockets = true;
        };
      };

      # Your Hosting Projects
      "anokxz.duckdns.org" = {
        enableACME = true;
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://localhost:8000";  # Projects server port (adjust as needed)
          proxyWebsockets = true;
        };
      };
    };
  };

  # ACME settings for Let's Encrypt
  security.acme = {
    acceptTerms = true;
    email = "snakshayan2@gmail.com";  # Replace with your email for Let's Encrypt
  };

  # Firewall settings
  networking.firewall.allowedTCPPorts = [ 80 443 ];
}
