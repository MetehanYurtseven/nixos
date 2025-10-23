{ config, lib, pkgs, ... }: {
  users = {
    defaultUserShell = pkgs.zsh;
    users."metehan.yurtseven" = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      openssh.authorizedKeys.keys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDyY8tYHfwirh+GaWBb1MKtB8M/UiL9+Yz5FoFqw4qBEEMJIpfXiS5W9qYD8ghbEa0QhpwEEqSkk2lfKUA3dR5ncKquZ3AtUIfYTjR5B4nCYBqmfcObVgLW9O0H0AjopUJRVSmXDFZEy9Ts4iAlcKpu4qM9pmaFleEq71A2Ud3lKU340chLxd0QjsPgbpwprXqBOAh2Wg1K8zej+L3/FUHco+4X3bgFXkdP0BsHWWQbKAxObPKaccAuJQg2PLcXIVOz+VHxqvijKqXw3jgzzkWAW9ynhrVLmbYYX9/sd3mY0oP+WXxiJ0tIacKCojlFxqkdoU9OtXOTe3S6TRKWzq0oRzhHfmLGubANev2mgrXlNPzxOJvKWFZQsKURjgxQjxu1Fgt9VxgRmSniIJl/s1QUnVobdnhoZk4sZu3fXFSXAMb3V6Za54s5aKYU9t7Xh066OzqRgtGeWerjbQ/LmdbOzrXUD4Zyp3xQzYduB/SxXzS3gLBFfTePHHMnWNO68jkUDghRvdBGDA4rr4tnQFUnde6y5nU4LKeZ+TRfA9rnJlALpJxNXSBtnKidouTxq7B0GzWEh8nSxDRoWG1qwpXYuGzcclVVg7IUIhKrmmo3VqOVdrwK54rRJzQONL8zoK/ZrxUDY88a6UgnXC3d656KgSu6/rGBPW1YCo21yjdBrw=="
      ];
    };
  };
}

