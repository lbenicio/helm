# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

  - feat(searxng): add SearXNG chart (StatefulSet, single volume for config+cache, node scheduling for local-path storage)

## [v0.1.1] — 2026-10-16

### Added

  - feat(infra): add an S3 and CloudFront CloudFormation stack for the Helm repository

### Changed

  - ci(release-charts): replace GitHub Pages deployment with AWS S3 synchronization and CloudFront invalidation
  - docs(readme): document AWS deployment and ACM certificate configuration

## [v0.1.0] — 2026-06-17

### Added

  - feat(ci): add landing page for Helm chart repository
  - feat(.github): add community health files and issue templates

### Changed

  - docs(README): update license badge from MIT to GPLv3
  - docs(readme): improve project description and add badges
  - ci(release-charts): migrate to GitHub Pages deployment
  - build(deps): bump actions/checkout from 4 to 6
  - build(deps): bump azure/setup-helm from 4 to 5
