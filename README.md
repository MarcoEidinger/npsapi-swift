# NatParkSwiftKit

[![Swift Package Manager Compatible](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg)](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

[![Build Status](https://travis-ci.com/MarcoEidinger/npsapi-swift.svg?branch=master)](https://travis-ci.com/MarcoEidinger/npsapi-swift)
[![](https://img.shields.io/badge/Protected_by-Hound-a873d1.svg)](https://houndci.com)
[![codebeat badge](https://codebeat.co/badges/9694c6d7-c09f-4b9d-9a58-10ce2783cb69)](https://codebeat.co/projects/github-com-marcoeidinger-npsapi-swift-master)
[![codecov.io](https://codecov.io/gh/MarcoEidinger/npsapi-swift/branch/master/graphs/badge.svg)](https://codecov.io/gh/MarcoEidinger/npsapi-swift/branch/master)
[![documentation](https://raw.githubusercontent.com/MarcoEidinger/npsapi-swift/master/docs/badge.svg?sanitize=true)](https://marcoeidinger.github.io/npsapi-swift/)

Swift library for the US National Park Service application program interface (NPS API). The API provides information about parks / monuments / historical sites throughout the US.

Required API key can be requested for free from [NPS Developer website](https://www.nps.gov/subjects/developer/get-started.htm)

## Disclaimer

Project is in **inital development state** and API incompatible changes can occur at any time in the master branch. As soon as the 1st release is done (~ Feb 2020) then API compatibility becomes target for future development activities.

## Installation

## Swift Package Manager

If you encounter any problem or have a question on adding package to an Xcode project, I suggest the [Adding Package Dependencies to Your App](https://developer.apple.com/documentation/xcode/adding_package_dependencies_to_your_app) guide article from Apple.

## Carthage

Add the following to your **Cartfile**.

```
github "MarcoEidinger/npsapi-swift" "master"
```

## Usage

Example to fetch information for a single park

```swift
import NatParkSwiftKit

let api = DataService(apiKey: "your-secret-API-key")
let cancellablePipeline = api.fetchParks()
	.replaceError(with: nil)
    .sink { (park) in
		guard let park = park else { return }
		print("Park \(park.parkCode) is a \(park.designation)")
    }
```

Parks and other entities of the National Park Service Data API can be fetched in bulks.

```swift
import NatParkSwiftKit

let api = DataService(apiKey: "your-secret-API-key")
let cancellablePipeline = api.fetchParks()
    .sink(receiveCompletion: { _ in
        print("Park request completed (either failed or was successful)")
    }, receiveValue: { (parks) in
        parks.forEach {
            print("Park \($0.parkCode) is a \($0.designation)")
        }
    }
)
```

As default the result set is limited to 50 records. This can be decreased or increased by setting **limit** in [`RequestOptions`](https://marcoeidinger.github.io/npsapi-swift/Structs/RequestOptions.html)

Below is a more complex search

```swift
import NatParkSwiftKit

let api = DataService(apiKey: "your-secret-API-key")
let publisher = api.fetchParks(by: nil, in: [.california], RequestOptions.init(limit: 5, searchQuery: "Yosemite National Park", fields: [.images, .entranceFees, .entrancePasses]))

let subscription = publisher
    .sink(receiveCompletion:
        { (completion) in
            switch completion {
            case .finished:
                print("Finished successfully")
            case .failure(let error):
                print(error)
            }
    }
    ) { (parks) in
        print(parks.count) // 1
}
```

Complete client-side API documentation is available [here](https://marcoeidinger.github.io/npsapi-swift/)

## Supported Types

* Parks
* Alerts
* NewsReleases
* VisitorCenters
* Places (a.k.a Assets)
