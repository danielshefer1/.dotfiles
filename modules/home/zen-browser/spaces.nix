{ ... }:

let
  icon = name: "chrome://browser/skin/zen-icons/selectable/${name}.svg";
in
{
  # Activation only edits zen-sessions.jsonlz4 while Zen is closed; otherwise it's skipped.
  # Essentials belong to a container, so each space's essentials share its container.
  programs.zen-browser.profiles.default = {
    spacesForce = true;
    pinsForce = true;
    pinsForceAction = "remove";

    spaces = {
      "Space" = {
        id = "7e5d84e5-b282-406c-8990-96f85c4b1742";
        position = 1000;
        icon = icon "bookmark";
        pins = {
          "YouTube" = {
            id = "513a2b50-f17d-4b4a-b699-d38182141b8b";
            url = "https://www.youtube.com";
            isEssential = true;
            position = 1;
          };
          "Rust Book" = {
            id = "4db673a6-0197-407b-99c8-5e6b4c5388e2";
            url = "https://doc.rust-lang.org/book/";
            isEssential = true;
            position = 2;
          };
          "Gmail" = {
            id = "5e0a6a86-125f-4a3f-b033-9c219a7bf99a";
            url = "https://mail.google.com/mail/u/0/#inbox";
            isEssential = true;
            position = 3;
          };
          "Claude" = {
            id = "7568643e-07f5-4f6b-aa79-2f654ac545cc";
            url = "https://claude.ai";
            isEssential = true;
            position = 4;
          };
          "LeetCode" = {
            id = "1937f719-79de-4e3c-aeb3-0ca74c1b9f9d";
            url = "https://leetcode.com";
            isEssential = true;
            position = 5;
          };
        };
      };

      "PO Dev" = {
        id = "a52bc2fa-aa56-4531-a790-71e7dabeade6";
        position = 2000;
        icon = icon "code";
        container = 6;
        pins = {
          "GitHub" = {
            id = "617fbeb1-a5e0-44eb-86b0-05629ff76738";
            url = "https://github.com";
            container = 6;
            isEssential = true;
            position = 1;
          };
          "Railway" = {
            id = "196c8f8a-a328-4d72-93d4-566ae77a2110";
            url = "https://railway.com/project/6a43f211-3396-4bb1-9aed-1668081b610c?environmentId=64007862-18cb-4d5c-9e17-e46e98556756";
            container = 6;
            isEssential = true;
            position = 2;
          };
          "Sentry" = {
            id = "8dd17267-3089-48e6-a289-088e54af342e";
            url = "https://daniel-shefer.sentry.io/issues/?project=4512150081437776";
            container = 6;
            isEssential = true;
            position = 3;
          };
          "Composio" = {
            id = "6282d635-9186-47ba-a2fe-7b831f0aebda";
            url = "https://dashboard.composio.dev/dandanshefer_workspace/Remi_PO_PRODUCTION/users";
            container = 6;
            isEssential = true;
            position = 4;
          };
          "Gmail" = {
            id = "a3c36132-da90-4eb9-8509-f921bfd5847e";
            url = "https://mail.google.com/mail/u/0/#inbox";
            container = 6;
            isEssential = true;
            position = 5;
          };
        };
      };
    };
  };
}
