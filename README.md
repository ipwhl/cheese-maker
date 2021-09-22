# How to add wheel

## Build config

Add a script like this for the wheel:

```yaml
name: Build <wheel name>

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
          curl <url to download wheel> -o <tarball name>
          tar -zxf <tarball name>
          mv <extracted directory>/* .
      - name: Build wheels
        run: python -m cibuildwheel --output-dir wheelhouse

      - name: package-xyz-0.0.1
        uses: softprops/action-gh-release@v1
        with:
          files: ./wheelhouse/*.whl
```

## Tag the release

Tag the release with the name of the release, with all lowercase

For example, if you build wheels for python-Levenshtein, version 0.12.0, the
tag would be python-levenshtein-0.12.0.

Afterwards, push the tag and the build config.

# Platform-dependent only

Note that the wheel must be platform-dependent.  Platform-independent wheels
can be built on sourcehut and can't be built with cibuildwheel.

