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

class BaseFileFilterTaskTests: AbstractSourceParsingTests {

    func test_filter_notSwift_verifyResult() {
        let url = fixtureUrl(for: "empty_lines_sources_list.txt")
        let task = MockComponentFileFilterTask(url: url, exclusionSuffixes: [], exclusionPaths: [])

        let result = try! task.execute()

        switch result {
        case .shouldProcess(_, _):
            XCTFail()
        case .skip:
            break
        }
    }

    func test_filter_swiftSuffixExcluded_verifyResult() {
        let url = fixtureUrl(for: "MultiLineInheritedTypes.swift")
        let task = MockComponentFileFilterTask(url: url, exclusionSuffixes: ["Types"], exclusionPaths: [])

        let result = try! task.execute()

        switch result {
        case .shouldProcess(_, _):
            XCTFail()
        case .skip:
            break
        }
    }

    func test_filter_swiftPathExcluded_verifyResult() {
        let url = fixtureUrl(for: "MultiLineInheritedTypes.swift")
        let task = MockComponentFileFilterTask(url: url, exclusionSuffixes: [], exclusionPaths: ["/Fixtures"])

        let result = try! task.execute()

        switch result {
        case .shouldProcess(_, _):
            XCTFail()
        case .skip:
            break
        }
    }

    func test_filter_swiftNonExcludedNoKeywordOrRegex_verifyResult() {
        let url = fixtureUrl(for: "MultiLineInheritedTypes.swift")
        let task = MockComponentFileFilterTask(url: url, exclusionSuffixes: ["Tests"], exclusionPaths: ["/Data"])

        let result = try! task.execute()

        switch result {
        case .shouldProcess(_, _):
            XCTFail()
        case .skip:
            break
        }
    }

    func test_filter_swiftNonExcludedHasMatch_verifyResult() {
        let url = fixtureUrl(for: "Components.swift")
        let task = MockComponentFileFilterTask(url: url, exclusionSuffixes: ["Tests"], exclusionPaths: ["/Data"])

        let result = try! task.execute()

        switch result {
        case .shouldProcess(let processUrl, let content):
            XCTAssertEqual(url, processUrl)
            XCTAssertEqual(content, try! String(contentsOf: url))
        case .skip:
            XCTFail()
        }
    }
}

private class MockComponentFileFilterTask: BaseFileFilterTask {

    override func filters(for content: String) -> [FileFilter] {
        return [KeywordRegexFilter(content: content, keyword: "Component", regex: Regex(": *Component *<"))]
    }
}
