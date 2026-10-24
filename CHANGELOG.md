# v1.1.2
## 10/24/2026

1. [](#bugfix)
    * Kept Grav's own `user/.htaccess` in the packages (unless the skeleton ships one), since replacing the `user/` folder dropped the extra protection Grav 2 adds there
    * Created any of the `user/` folders Grav needs (accounts, config, data, pages, plugins, themes) that a skeleton leaves out, since a missing `user/accounts` stops a fresh install with a Grav Problems page
    * Left every `.github/` folder out of the packages, not only `.github/workflows/`
1. [](#improved)
    * Updated the example workflow and noted that `.dependencies` entries should use stable branches

# v1.1.1
## 08/07/2026

1. [](#bugfix)
    * Excluded `cache/compiled/` from the generated packages, since running `bin/grav install` and `bin/gpm install admin` during the build left compiled blueprint/config caches inside the zips

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
