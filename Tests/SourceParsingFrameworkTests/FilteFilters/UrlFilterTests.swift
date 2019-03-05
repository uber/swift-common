//
//  Copyright (c) 2018. Uber Technologies
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import XCTest
@testable import SourceParsingFramework

class UrlFilterTests: AbstractSourceParsingTests {

    func test_filter_notSwift_verifyResult() {
        let url = fixtureUrl(for: "empty_lines_sources_list.txt")
        let filter = UrlFilter(url: url, exclusionSuffixes: [], exclusionPaths: [])

        let result = filter.filter()

        XCTAssertFalse(result)
    }

    func test_filter_swiftSuffixExcluded_verifyResult() {
        let url = fixtureUrl(for: "MultiLineInheritedTypes.swift")
        let filter = UrlFilter(url: url, exclusionSuffixes: ["Types"], exclusionPaths: [])

        let result = filter.filter()

        XCTAssertFalse(result)
    }

    func test_filter_swiftPathExcluded_verifyResult() {
        let url = fixtureUrl(for: "MultiLineInheritedTypes.swift")
        let filter = UrlFilter(url: url, exclusionSuffixes: [], exclusionPaths: ["/Fixtures"])

        let result = filter.filter()

        XCTAssertFalse(result)
    }

    func test_filter_swiftNonExcluded_verifyResult() {
        let url = fixtureUrl(for: "MultiLineInheritedTypes.swift")
        let filter = UrlFilter(url: url, exclusionSuffixes: ["Tests"], exclusionPaths: ["/Data"])

        let result = filter.filter()

        XCTAssertTrue(result)
    }
}
