{ ... }:

{
  programs.claude-code = {
    enable = true;

    # Declared keys are merged into ~/.claude/settings.json on every rebuild, but the
    # file stays writable so /config, /plugin and auto-mode can still save changes
    mutableSettings = true;

    settings = {
      env = {
        CLAUDE_CODE_SCROLL_SPEED = "5";
        # Local mods stay in ~/.claude/mods because the plugin-authoring skill edits them in place
        CLAUDE_CODE_PLUGIN_DIRS = "~/.claude/mods/prompt-band:~/.claude/mods/subagent-roadmap";
      };

      enabledPlugins = {
        "security-guidance@anthropic-plugin-directory" = true;
        "railway@anthropic-plugin-directory" = true;
        "superpowers@claude-plugins-official" = true;
        "claude-code-setup@claude-plugins-official" = true;
        "sentry@anthropic-plugin-directory" = true;
        "context7@anthropic-plugin-directory" = true;
        "remember@claude-plugins-official" = true;
        "pyright-lsp@claude-plugins-official" = true;
        "claude-md-management@claude-plugins-official" = true;
        "claude-security@claude-plugins-official" = true;
        "frontend-design@claude-plugins-official" = true;
        "ponytail@ponytail" = true;
      };

      extraKnownMarketplaces.ponytail.source = {
        source = "github";
        repo = "DietrichGebert/ponytail";
      };

      modelSettings.claude-opus-5-5.effortLevel = "high";

      tui = "fullscreen";
      # ~/.claude/themes/noctalia.json is rendered by the noctalia claude-code template
      theme = "custom:noctalia";
      agentPushNotifEnabled = false;

      autoMode.environment = [
        "### Org-wide"
        "**Organization**: None configured"
        "**Cloud provider(s)**: None configured"
        "**Repository visibility**: PUBLIC — danielshefer1/.dotfiles (confirmed via gh)"
        "**Internal sharing / snippet hosting**: None configured — treat public paste/gist services as outside the trust boundary"
        "**Secrets management**: None configured"
        "**Default / protected branches**: default branch unknown (origin/HEAD unset); no rulesets listed, no protected branches listed on danielshefer1/.dotfiles"
        "**CI/CD deploy targets**: None configured"
        "**Network posture**: None configured"
        "**Host containment**: None configured — assume Claude Code runs on an ordinary developer machine or CI runner with open internet"
        "**Source control**: The trusted repo (danielshefer1/.dotfiles) and its origin remote (github.com:danielshefer1/.dotfiles.git) only — no additional orgs configured"
        "**Trusted internal domains**: None configured"
        "**Trusted cloud buckets**: None configured"
        "**Key internal services**: None configured"
        "**Internal package registry**: None configured"
        "**Sensitive data locations & audiences**: any file or store holding personal data, confidential business data, credentials, regulated data, or similarly sensitive material; preserve exact handles when known and share only with audiences cleared at the [named+specifics] bar"
        "**Data retention / declassification**: None configured"
        "**Sensitive remote targets**: any namespace, host, or container whose name carries `prod` or `production` as a whole word or name segment"
        "**Protected deployment namespaces / environments**: None configured — fall back to the Sensitive remote targets heuristic"
        "**Protected IaC scopes**: IAM, RBAC, networking, quota, and node-pool resources; anything whose name or tag carries `prod` or `production` as a whole word or name segment"
        "### User-specific"
        "**Primary use of Claude Code**: personal dotfiles / NixOS system configuration management (hobby use)"
        "**Trusted repo**: /home/daniels/.dotfiles (public repo, origin github.com:danielshefer1/.dotfiles.git) — since this repo is PUBLIC, only this repo's own work belongs in it; confidential material or content ported from elsewhere is not cleared for commit/push here"
        "**Org-specific CLIs**: None configured — user runs nix/nixos-rebuild, rclone, cargo, uv, railway routinely outside Claude per shell history, but these are personal tooling, not org-specific"
      ];
    };
  };
}
