{ ... }:

{
  programs.zen-browser.profiles.default = {
    containersForce = true;
    containers = {
      Personal = {
        id = 1;
        icon = "fingerprint";
        color = "blue";
      };
      Work = {
        id = 2;
        icon = "briefcase";
        color = "orange";
      };
      Banking = {
        id = 3;
        icon = "dollar";
        color = "green";
      };
      Shopping = {
        id = 4;
        icon = "cart";
        color = "pink";
      };
      "PO Dev" = {
        id = 6;
        icon = "briefcase";
        color = "toolbar";
      };
    };
  };
}
