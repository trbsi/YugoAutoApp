# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres
to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.3] - 2023-04-09

### Fixed

- Non yugoauto.com links should be open in a browser. Solution found
  here https://stackoverflow.com/questions/65292270/flutter-webview-opening-external-links-in-browser-or-window
- Move URL generator to its own service

## [1.0.2] - 2023-04-09

### Fixed

- Fix soft keyboard covering text input on display. Whenever softkeyboard was
  displayed it covered text input and it could not be scrolled. Resolved
  via https://stackoverflow.com/questions/67286328/flutter-webview-text-input-gets-hidden-by-soft-keyboard

## [1.0.0] - 2023-04-03

### Added

- MVP
