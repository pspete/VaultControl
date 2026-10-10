# Changelog

All notable changes to this project will be documented in this file.

## Unreleased

- N/A

## [1.2.0] - 2026-10-10

### Added

- Add `New-PARPassFile`
  - Creates an encrypted PARClient password file for use with `-PassFile`.

### Changed

- Update `Get-PARServer` & `Get-PARServerLog`
  - Fixed parsing of PARAgent 15.x output, which includes a `PARAgent version` header line.
- Update `Get-PARServerLog`
  - `TimeFrom` defaults to 24 hours before the current time.
  - Fixed error when no events are returned.
  - `EventID` returned as the standard event ID (e.g. `7036`) instead of the raw value including qualifier bits (e.g. `1073748860`).
- Update `Invoke-PARClient`
  - Uses a new state file for each command, deleted on completion ([#11](https://github.com/pspete/VaultControl/issues/11)).
    - Repeated log queries no longer return only records unread by a previous query.
    - `<PID>.tmp` state files are no longer left in the temp directory.
  - No longer outputs the `$PAR` variable alongside command results.
  - `PassFile` path is quoted, allowing paths containing spaces.
  - Detects `CLP`-prefixed errors & multi-line error output.
  - Output containing `(<Text>: <Number>)` is no longer reported as an error; only `(Reason: <Number>)` is.
- Resolved PSScriptAnalyzer findings.
- Tests no longer delete or overwrite the user's `PARConfiguration.xml`.
- Help is now external help (`en-US/VaultControl-help.xml`), generated from the command markdown in `docs/collections/_commands`.
- Build, test and release moved from AppVeyor to GitHub Actions.

## [1.1.54] - 2020-02-12

- Update `Get-PARServer`
  - Corrected property name in output & description in help text.
  - Updated to show disk data for any partitions additional to `C:\`

## [1.0.46] - 2019-02-18

- 1.0 Release
- Published to PowerShell Gallery