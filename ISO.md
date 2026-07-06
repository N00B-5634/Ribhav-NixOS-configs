# ISO Release (Legacy Status)

- [Preamble & Deprecation Notice](#preamble--deprecation-notice)
- [Why is this image Legacy?](#why-is-this-image-legacy)
- [Features (Historical Profile)](#features-historical-profile)
- [System Requirements](#system-requirements)
- [Final Notes](#final-notes)

## Preamble & Deprecation Notice

Greetings,

This is N00B-5634. Please do note that this standalone desktop installation ISO is now considered a **legacy artifact**. It is no longer actively maintained or updated. 

> ⚠️ **Platform Note:** The compiled bootable `.iso` image asset is hosted **exclusively on the GitHub repository releases page**. If you are viewing this repository on Codeberg, head over to GitHub to grab the raw image tag, but read the architectural warnings below before attempting an installation.

---

## Why is this image Legacy?

The repository has undergone a complete architectural shift away from its original structure:

1. **Shift to Server Architecture:** This entire repository has transitioned from a localized graphical desktop workflow into a production-hardened server and headless remote management platform. 
2. **Desktop Utilities Dropped:** Standard workstation tools, visual configuration parameters, and heavy desktop environments (including the old KDE Plasma 6 setup) have been stripped from the operational baseline. If you are looking to set up an active mobile terminal workstation, do not use this ISO—deploy **`laptop-configuration.nix`** from the root of this repository instead.
3. **End-of-Life Platform Basis:** This snapshot was compiled using **NixOS 25.05**, which has been officially **End-of-Life (EOL) for over a full year**. It receives absolutely no security updates, software backports, or package maintenance from upstream channels. 

*Use this image with extreme caution, preferably inside an isolated testing sandbox or virtual machine environment.*

---

## Features (Historical Profile)

For historical reference, this snapshot contains:
- Pre-configured NixOS workstation desktop environment base.
- Pre-installed utility sets configured for everyday desktop productivity.
- Early stage performance optimizations and personalized shell assets.

---

## System Requirements

- **Processor:** 64-bit x86_64 architecture
- **Memory:** Minimum of 4GB RAM 
- **Storage:** At least 20GB of available disk space
- **Deployment:** USB bootable flash media or standard Hypervisor virtual machine disk layers.

### Final Notes

Thank you for your continued interest in the evolution of this infrastructure config. 

Until next time...

> -- "Hi, I despise markdown." N00B-5634, November 20, 2025
