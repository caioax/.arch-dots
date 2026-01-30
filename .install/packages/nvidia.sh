#!/bin/bash
# =============================================================================
# NVIDIA Packages - NVIDIA GPU Support (OPTIONAL)
# =============================================================================
# Packages for NVIDIA GPU support in hybrid systems
# Install only if you have an NVIDIA GPU
# =============================================================================

NVIDIA_PACKAGES=(
    # # Drivers
    # "nvidia-open-dkms" # NVIDIA proprietary driver
    # "nvidia-utils"     # NVIDIA utilities
    # "nvidia-settings"  # NVIDIA settings GUI
    #
    # # Video Acceleration
    # "libva-nvidia-driver" # VA-API driver for NVIDIA
    #
    # # For hybrid graphics (Intel + NVIDIA)
    # "intel-media-driver" # Intel VA-API driver
    # "libva-utils"        # VA-API utilities (vainfo)
)

# AUR packages
NVIDIA_AUR_PACKAGES=(
    # No mandatory AUR packages
)

# Note: After installing NVIDIA drivers, the setup script will
# configure the necessary environment variables automatically.
