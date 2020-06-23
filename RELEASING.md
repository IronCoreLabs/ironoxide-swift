# Release process

- Make sure all changes to be released are on `master`.
- Decide what the new version number should be (we use semver).
- Make sure `CHANGELOG.md` is up to date with the latest changes.
- If needed, commit `CHANGELOG.md` to your local git.
  - Use the changelog entry for the release as the commit message.
- Tag the release, using the changelog entry as the commit message.
  - `git tag -a <NEW_VER_NUM>` (e.g. 0.13.2)
  - `git push origin <NEW_VER_NUM> && git push`
