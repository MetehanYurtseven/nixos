{ config, lib, pkgs, ... }: {
  hardware.graphics.enable = true;
  hardware.amdgpu.opencl.enable = true;
}

