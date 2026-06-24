# v1.1.0
## 06/24/2026

1. [](#improved)
    * Updated the builder image to **PHP 8.3** so it can package **Grav 2.0** (which requires PHP 8.3+), while still building older Grav releases
    * Switched `gd` to build with freetype, jpeg, and webp support, and pulled Composer from the official image instead of the web installer
1. [](#bugfix)
    * Fixed the documented workflow so the upload step targets the bare tag (`github.ref_name`) instead of the full `refs/tags/...` ref, which previously created a stray release on publish

# v1.0.1
## 02/25/2021

1. [](#bugfix)
    * Minor fixes

# v1.0.0
## 02/25/2021

1. [](#new)
    * Initial release
