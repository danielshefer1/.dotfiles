{ ... }:

{
  # Zen theme-store mods, fetched on activation; restart Zen to apply
  programs.zen-browser.profiles.default.mods = [
    "d8b79d4a-6cba-4495-9ff6-d6d30b0e94fe" # Better Active Tab
    "253a3a74-0cc4-47b7-8b82-996a64f030d5" # Floating History
    "f4866f39-cfd6-4498-ab92-54213b8279dc" # Animations Plus
    "bc25808c-a012-4c0d-ad9a-aa86be616019" # sleek border
    "a6335949-4465-4b71-926c-4a52d34bc9c0" # Better Find Bar
    "a5f6a231-e3c8-4ce8-8a8e-3e93efd6adec" # Cleaned URL bar
  ];
}
