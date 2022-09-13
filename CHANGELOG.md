# Changelog

## 0.16.0

- Upgrade to homebrew ironoxide 0.15.0.
  - Additional fields were added to `JwtClaims`.
  - Most of the `JwtClaims` fields are now optional.
  - Some of the `JwtClaims` fields changed from `UInt32` to `Int64`.

## 0.15.0

- Upgrade to homebrew ironoxide 0.14.7.
  - This required a few `JwtClaims.pid` and `JwtClaims.kid` to change from type `UInt` to `UInt32`.
- Update README.md directions for local building/testing.

## 0.14.0

- Add `Jwt` and `JwtClaims` types
- Change `userCreate`, `userVerify`, and `generateNewDevice` to use new JWT types

## 0.13.2

- Initial open source version
