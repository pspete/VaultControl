# Changelog

All notable changes to this project will be documented in this file.

## [Unreleased]

- Add `New-PARPassFile`
  - Creates an encrypted PARClient password file for use with `-PassFile`.
- Update `Get-PARServer` & `Get-PARServerLog`
  - Fixed parsing of PARAgent 15.x output, which includes a `PARAgent version` header line.
- Update `Get-PARServerLog`
  - Help text describes behaviour when `TimeFrom` is not specified.
  - Fixed error when no events are returned.
- Update `Invoke-PARClient`
  - `PassFile` path is quoted, allowing paths containing spaces.
  - Detects `CLP`-prefixed errors & multi-line error output.
  - Output containing `(<Text>: <Number>)` is no longer reported as an error; only `(Reason: <Number>)` is.
- Resolved PSScriptAnalyzer findings.
- Tests no longer delete or overwrite the user's `PARConfiguration.xml`.

## [1.1.54] - 2020-02-12

- Update `Get-PARServer`
  - Corrected property name in output & description in help text.
  - Updated to show disk data for any partitions additional to `C:\`

## [1.0.46] - 2019-02-18

- 1.0 Release
- Published to PowerShell Gallery