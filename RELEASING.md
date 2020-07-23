# Release process

- Make sure that any changes necessary for this release are included in a released `ironoxide` Homebrew version. An updated HomeBrew tar should be released prior to this library getting released.
- Make sure all changes to be released are on `master`.
- Decide what the new version number should be (we use semver).
- Make sure `CHANGELOG.md` is up to date with the latest changes.
- If needed, commit `CHANGELOG.md` to your local git.
  - Use the changelog entry for the release as the commit message.
- Make sure the version compatibility table in the README is up to date so that developers know which version of the Homebrew `ironoxide` library they need to have installed.
- Commit the `README.md` changes.
- Tag the release, using the changelog entry as the commit message.
  - `git tag -a <NEW_VER_NUM>` (e.g. 0.13.2)
  - `git push origin <NEW_VER_NUM> && git push`
