# CUPS
CUPS is an open-source printing system for Linux® and other Unix®-like operating systems.
Please refer to OpenPrinting CUPS for more information https://github.com/openprinting/cups

Print My Barcode utilises CUPS to identify printers on the network and fulfill its print jobs.

# Docker
This folder is used to create a debian-based docker image with a customised cups configuration.
To build the docker image described in this folder please use:

**CUPS build and publish** workflow described in .github/workflows/cups-build-and-publish.yml

Note: When updating the image please version the image according to SemVer standards. Available at: https://semver.org/.
