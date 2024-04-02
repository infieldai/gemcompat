This project is maintained by the team at [Infield](https://infield.ai), you can reach us at hello@infield.ai.

# What this project does

## TLDR
Use this script to check whether your app relies on gems which are
silently incompatible with a package upgrade. For example, check if
you're compatible with Rails 7.1 like this:

```
    gemcompat --package rails --target-version 7.1 --lockfile Gemfile.lock
```

## Package support

gemcompat supports checking the following upgrades:

|package|target version|
|------|-------|
|rails|7.1|
|rails|6.1|

Please contribute to the database to support more packages and targets!

## Motivation
Upgrading Rails means first upgrading other dependencies that block
the way. Some of these will have explicit incompatibilities documented
in their gemspecs. If you try to run `bundle update rails` without
upgrading these gems you'll see an error that bundler couldn't resolve
the upgrade.

Other gems leave an open-ended rails requirement in their
gemspec. This means bundler will allow a new version of Rails
alongside your current version of those gems, but there's no guarantee
from the maintainer that the two are compatible. This can lead to
subtle bugs that don't get caught until production.

For example, take the popular `data-migrate` gem. Its gemspec requires
activerecord >= 6.1 with no upper bound. Looking at the changelog,
though, you'll see that support for Rails 7.1 wasn't added until
version 9.2.0. Older versions will hit this exception when someone
tries to run migrations under the latest Rails, even though bundler
installs the package with no warning.

These "silent" incompatibilities are often documented in the
maintainer’s changelog even though they’re not available to
bundler. This project serves as a repository for storing these
incompatibilities as we discover them, and includes code to
automatically check your project against the database.

# Installation
```
    gem install gemcompat
```

# Contributing

We welcome contributions, both to the dataset and to the code itself.

## Adding an incompatibility
Incompatibilities are stored in the `data/` directory, with one folder
per package and one file per target version of that package.

For instance, gems which are incompatible with Rails 7.1 should be
documented in `data/rails/7_1.yaml`.

Here's an example from rails/7_1.yaml

```yaml
  activerecord-import:
  :first_compatible_version: 1.5.0
```

This means that the activerecord-import gem needs to be at least
version 1.5.0 in order to be compatible with Rails 7.1

## Development

Getting started should be easy. You'll need to have Ruby 3.3 installed
and run bundle to install the developer dependencies. You can run specs with:

```
bundle exec rspec
```
