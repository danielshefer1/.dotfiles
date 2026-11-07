{ lib, ... }:

let
  prefs = {
    # Zen UI
    "zen.view.compact.enable-at-startup" = false;
    "zen.view.sidebar-expanded" = false;
    "zen.view.use-single-toolbar" = false;
    "zen.library.media.enabled" = true;
    "sidebar.visibility" = "hide-launcher";
    "extensions.activeThemeID" = "firefox-compact-dark@mozilla.org";
    "toolkit.legacyUserProfileCustomizations.stylesheets" = true;

    # Browsing / privacy
    "browser.search.suggest.enabled" = true;
    "browser.bookmarks.showMobileBookmarks" = false;
    "extensions.formautofill.creditCards.enabled" = false;
    "findbar.highlightAll" = true;
    "intl.regional_prefs.use_os_locales" = true;
    "network.http.speculative-parallel-limit" = 0;
    "network.prefetch-next" = false;
    "privacy.clearOnShutdown_v2.formdata" = true;
    "signon.rememberSignons" = false;

    # Mod options (mods themselves are in mods.nix)
    "mod.cleanedurlbar.customcolor" = "hsl(0 0 10)";
    "mod.cleanedurlbar.customselectcolor" = "rgba(80, 80, 250, 0.75)";
    "mod.cleanedurlbar.customselectfontcolor" = "rgba(255,255,255,1)";
    "mod.cleanedurlbar.customtransparency" = "40%";
    "mod.sameerasw.zen_bg_blur" = "3px";
    "mod.sameerasw.zen_bg_color_enabled" = false;
    "mod.sameerasw.zen_bg_img_enabled" = false;
    "mod.sameerasw.zen_bg_img_not_fullscreen" = false;
    "mod.sameerasw.zen_bg_opacity" = "0.8";
    "mod.sameerasw.zen_compact_sidebar_width" = "165px";
    "mod.sameerasw.zen_no_shadow" = false;
    "mod.sameerasw.zen_notab_img_opacity" = "1";
    "mod.sameerasw.zen_notab_img_size" = "150px";
    "mod.sameerasw.zen_tab_switch_anim" = true;
    "mod.sameerasw.zen_trackpad_anim" = false;
    "mod.sameerasw.zen_transparency_color" = "#00000000";
    "mod.sameerasw.zen_transparent_glance_enabled" = true;
    "mod.sameerasw.zen_transparent_sidebar_enabled" = true;
    "mod.sameerasw.zen_urlbar_zoom_anim" = false;
    "mod.sameerasw_zen_animations" = "1";
    "mod.sameerasw_zen_compact_sidebar_type" = "0";
    "mod.sameerasw_zen_empty_tab_logo" = "0";
    "mod.sameerasw_zen_light_tint" = "2";
    "theme-better_find_bar-enable_custom_background" = false;
    "theme.better-active-tab.on-right" = false;
    "theme.better_find_bar.custom_background" = "#112233";
    "theme.better_find_bar.hide_find_status" = false;
    "theme.better_find_bar.hide_found_matches" = false;
    "theme.better_find_bar.hide_highlight" = "not_hide";
    "theme.better_find_bar.hide_match_case" = "not_hide";
    "theme.better_find_bar.hide_match_diacritics" = "not_hide";
    "theme.better_find_bar.hide_whole_words" = "not_hide";
    "theme.better_find_bar.horizontal_position" = "default";
    "theme.better_find_bar.instant_animations" = false;
    "theme.better_find_bar.textbox_width" = "800";
    "theme.better_find_bar.transparent_background" = true;
    "theme.better_find_bar.vertical_position" = "default";
    "theme.floating_history.position" = "right";
  };
in
{
  # Not profiles.default.settings: that makes user.js a read-only symlink, and noctalia's zen
  # template rewrites user.js on every palette change. Autoconfig pref() is reapplied each start.
  programs.zen-browser.extraPrefs = lib.concatLines (
    lib.mapAttrsToList (k: v: "pref(${builtins.toJSON k}, ${builtins.toJSON v});") prefs
  );
}
