# Contributing

All contributions welcomed and are appreciated.

## PowerShell Styleguide

Use the standard *Verb*-*Noun* convention, and only use approved verbs.

Public functions use external help: add or update the command's markdown file in [docs/collections/_commands](docs/collections/_commands), which is the source of truth for `Get-Help`.

Every public function needs a Pester test file in [Tests](Tests).

[K&R (One True Brace Style variant)](https://github.com/PoshCode/PowerShellPracticeAndStyle/issues/81) preferred.

## Contributing Code

- Fork the repo.
- Push your changes to your fork.
- Write a [good commit message][commit]
- Describe the change under `## Unreleased` in [CHANGELOG.md](CHANGELOG.md); the version number is set from these notes (there is no need to change it manually).
- Submit a pull request
  - Keep pull requests limited to a single issue
  - Discussion, or necessary changes may be needed before merging the contribution.

[commit]: http://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html
