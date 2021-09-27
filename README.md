# How to add wheel

## Build config

Add a script like this for the wheel:

```yaml
name: <Package name and version>

defaults:
  run:
    shell: bash

on: pull_request

jobs:
  build_wheels:
    name: Build wheels on ${{ matrix.os }}
    runs-on: ${{ matrix.os }}
    strategy:
      matrix:
        os: [ubuntu-20.04, windows-2019, macos-10.15]

    steps:
      - uses: actions/checkout@v2

      # Used to host cibuildwheel
      - uses: actions/setup-python@v2

      - name: Install cibuildwheel
        run: python -m pip install cibuildwheel==2.1.2

      - name: Fetch source distribution
        run: |
          curl <sdist tarball URL>
          tar -zxf <sdist tarball file>
          mv <extracted tarbal dir>/* .

      - name: Build wheels
        run: python -m cibuildwheel --output-dir wheelhouse
        env:
          CIBW_PROJECT_REQUIRES_PYTHON: ">=3.7"
          CIBW_BUILD: "cp*"

      - name: Checksum Linux
        if: ${{ runner.os == 'Linux' }}
        run: sha256sum wheelhouse/*

      - name: Checksum Windows
        if: ${{ runner.os == 'Windows' }}
        run: |
          for file in $(ls wheelhouse)
          do
            certutil -hashfile wheelhouse/$file SHA256
          done

      - name: Checksum Mac
        if: ${{ runner.os == 'macOS' }}
        run: shasum -a 256 wheelhouse/*

      - uses: actions/upload-artifact@v2
        with:
          path: wheelhouse/*.whl

      - name: Release
        uses: softprops/action-gh-release@v1
        with:
          name: 'Release: <package name-version>'
          files: wheelhouse/*.whl
          tag_name: <release tag>
```

## Tag the release

Tag the release with the name of the release, with all lowercase

For example, if you build wheels for python-Levenshtein, version 0.12.0, the
tag would be python-levenshtein-0.12.0.

Afterwards, push the tag and the build config.

# Platform-dependent only

Note that the wheel must be platform-dependent.  Platform-independent wheels
can be built on sourcehut and can't be built with cibuildwheel.

