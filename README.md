# lab-files-ios

A small iPhone app for a home lab: a File Provider extension that will show a self-hosted server's folders in the
Files app, keep chosen folders offline, and carry deletes both ways.

**Status: probe.** This first version only proves the pipeline: the app checks its App Group and registers a "Lab"
location in Files, and the extension lists one static file, `hello.txt`.

**How it gets built and installed.** GitHub Actions (`.github/workflows/ios-unsigned.yml`) builds it unsigned on a
macOS runner with XcodeGen + Xcode, ad-hoc signs each bundle only to carry the App Group entitlement, and uploads
`Lab-unsigned.ipa`. Signing with a free Apple ID and installing over USB happen on the owner's own machines, never
here. The group is named `group.io.github.ryanlhicks.lab` in source and baked as
`group.io.github.ryanlhicks.lab.<TEAMID>`, the name free-team signers give it (repository variable `FREE_TEAM_ID`).

No server address, token or personal data belongs in this repository: the app is told its server at run time.
