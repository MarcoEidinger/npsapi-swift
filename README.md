# npsapi-swift

[![Swift Package Manager Compatible](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg)](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg)
[![Build Status](https://travis-ci.com/MarcoEidinger/npsapi-swift.svg?branch=master)](https://travis-ci.com/MarcoEidinger/npsapi-swift)
[![](https://img.shields.io/badge/Protected_by-Hound-a873d1.svg)](https://houndci.com)
[![codebeat badge](https://codebeat.co/badges/9694c6d7-c09f-4b9d-9a58-10ce2783cb69)](https://codebeat.co/projects/github-com-marcoeidinger-npsapi-swift-master)
[![codecov.io](https://codecov.io/gh/MarcoEidinger/npsapi-swift/branch/master/graphs/badge.svg)](https://codecov.io/gh/MarcoEidinger/npsapi-swift/branch/master)
[![documentation](https://raw.githubusercontent.com/MarcoEidinger/npsapi-swift/master/docs/badge.svg?sanitize=true)](https://marcoeidinger.github.io/npsapi-swift/)

Swift library for the US National Park Service application program interface (NPS API). The API provides information about parks / monuments / historical sites throughout the US.

Required API key can be requested for free from [NPS Developer website](https://www.nps.gov/subjects/developer/get-started.htm)

## Installation

If you encounter any problem or have a question on adding package to an Xcode project, I suggest the [Adding Package Dependencies to Your App](https://developer.apple.com/documentation/xcode/adding_package_dependencies_to_your_app) guide article from Apple.

## Usage

Example to fetch park related information

```swift
let cancellablePipeline = api.fetchParks()
    .sink(receiveCompletion: { (error) in
        print("Park request failed: \(String(describing: error))")
    }, receiveValue: { (parks) in
        parks.forEach {
            print("Park \($0.parkCode) is a \($0.designation)")
        }
    }
)
```

Complete client-side API documentation is available [here](https://marcoeidinger.github.io/npsapi-swift/)

## Supported Types

* Parks
* Alerts
* NewsReleases
