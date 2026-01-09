{ settings, ... }:
{
  services.swaync = {
    enable = true;

    settings = {
      positionX = "right";
      positionY = "top";
      notification-icon-size = 64;
      timeout = 10;
      timeout-critical = 0;
    };

    style = ''
      /* Rose Pine Colors */
      @define-color base    #191724;
      @define-color surface #1f1d2e;
      @define-color overlay #26233a;
      @define-color muted   #6e6a86;
      @define-color subtle  #908caa;
      @define-color text    #e0def4;
      @define-color love    #eb6f92;
      @define-color iris    #c4a7e7;
      @define-color pine    #31748f;
      @define-color foam    #9ccfd8;

      * {
        font-family: "${settings.appearance.displayFont}", sans-serif;
        font-size: 14px;
      }

      .notification-row {
        outline: none;
        margin: 8px;
        margin-right: 12px;
        padding: 0;
      }

      .notification-row:hover .notification {
        background: @overlay;
      }

      .notification {
        background: @overlay;
        border-radius: 12px;
        border: 2px solid @muted;
        padding: 0;
        margin: 0;
      }

      .notification-default-action {
        background: transparent;
      }

      .notification-default-action:hover {
        background: transparent;
      }

      .notification-content {
        background: transparent;
        padding: 12px;
      }

      .close-button {
        background: transparent;
        color: @love;
        border: none;
        padding: 2px;
        margin: 4px;
        min-width: 20px;
        min-height: 20px;
        font-size: 12px;
      }

      .close-button:hover {
        background: transparent;
        color: @love;
      }

      .summary {
        font-weight: bold;
        color: @text;
      }

      .body {
        color: @subtle;
      }

      .control-center {
        background: @base;
        border: 1px solid @overlay;
        border-radius: 12px;
      }

      .notification.critical {
        border: 2px solid @love;
      }
    '';
  };
}
