# Swift Common

[![Build Status](https://travis-ci.com/uber/swift-common.svg?branch=master)](https://travis-ci.com/uber/swift-common?branch=master)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

## Requirements

- Xcode 9.3+
- Swift 4.0+

## Overview

Swift-Common contains reusable modules shared among a number of Uber's Swift open source projects, such as [Needle](https://github.com/uber/needle), [Swift Abstract Class](https://github.com/uber/swift-abstract-class) and etc. This code is not specifically designed for external consumption beyond Uber's open source projects. However, it is certainly possible for other projects to depend on these libraries.

### SourceParsingFramework

This framework contains common code used for filtering and parsing Swift source code.

### CommandFramework

This framework contains common code for parsing command line arguments.

## Installation

Since Uber's Swift open source projects use [Swift Package Manager](https://github.com/apple/swift-package-manager) this project only supports installation via SPM. Please refer to the standard SPM package setup for details.

## Building

First fetch the dependencies:

```bash
$ swift package resolve
```

You can then build from the command-line:

```bash
$ swift build
```

Or create an Xcode project and build using the IDE:

```bash
$ swift package generate-xcodeproj
```

## Testing

From command-line.

```bash
$ swift test
```

Or you can follow the steps above to generate a Xcode project and run tests within Xcode.

## Related projects

If you like Swift Common, check out other related open source projects from our team:
- [Needle](https://github.com/uber/needle): a compile-time safe Swift dependency injection framework.
- [Swift Abstract Class](https://github.com/uber/swift-abstract-class): a light-weight library along with an executable that enables compile-time safe abstract class development for Swift projects.
- [Swift Concurrency](https://github.com/uber/swift-concurrency): a set of concurrency utility classes used by Uber, inspired by the equivalent [java.util.concurrent](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/package-summary.html) package classes.

## License
[![FOSSA Status](https://app.fossa.io/api/projects/git%2Bgithub.com%2Fuber%2Fswift-concurrency.svg?type=large)](https://app.fossa.io/projects/git%2Bgithub.com%2Fuber%2Fswift-concurrency?ref=badge_large)
