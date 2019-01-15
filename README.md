# Release notes

Release versions are in the format: *<major_version>.<minor_version>.<build_number>*.

## How to check what work is unfinished for the current release

This checks for un-QAed changes since the the start of time. It is run in the *Check release* build step.

./bin/notes --check-unfinished <new_release_version>

## How to create release notes for the current release

The *notes* program magically figures out what has changed since the last release and list those changes. This is run in the *Release notes* build step:

./bin/notes <new_release_version>

## How to prepare release notes for Retro

Retro notes are usually prepared by time period, i.e. since the last release before the current iteration:

- Check out *release-notes* project

- Ensure that you have all the current .env variables from the Release notes  step in the Core Service commit build

- Find the build number of the last release before the date you are interested in (from Buildkite)

- Find the build number of the most recent release

- Run: ./bin/notes -p <old_release_version> <new_release_version>

- Profit!

