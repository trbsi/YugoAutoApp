# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres
to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.5] - 2023-04-13

### Changed

- If 24 hour passes resend push token to the server, just in case something happens we will resend
  token every 24 hours, thus ensure that token will be saved on server

## [1.0.4] - 2023-04-10

### Fixed

- Fix problem with opening external URLs in browser in Android. This is fix on top of 1.0.3. Now it
  opens pages in real browser such as Safari or Chrome

## [1.0.3] - 2023-04-09

### Fixed

- Non yugoauto.com links should be open in a browser. Solution found
  here https://stackoverflow.com/questions/65292270/flutter-webview-opening-external-links-in-browser-or-window

### Changed

- Move URL generator to its own service (UrlService)
- Replace webview callbacks with private functions in MyCustomWebview

## [1.0.2] - 2023-04-09

### Fixed

- Fix soft keyboard covering text input on display. Whenever soft keyboard was
  displayed it covered text input and it could not be scrolled. Resolved
  via https://stackoverflow.com/questions/67286328/flutter-webview-text-input-gets-hidden-by-soft-keyboard

## [1.0.0] - 2023-04-03

### Added

- MVP
