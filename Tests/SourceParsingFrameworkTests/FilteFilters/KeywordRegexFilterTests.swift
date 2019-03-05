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

class KeywordRegexFilterTests: AbstractSourceParsingTests {

    private var content: String!

    override func setUp() {
        super.setUp()

        let contentUrl = fixtureUrl(for: "Components.swift")
        content = try! String(contentsOf: contentUrl)
    }

    func test_filter_noKeyword_verifyResult() {
        let filter = KeywordRegexFilter(content: content, keyword: "blah", regex: Regex("."))

        let result = filter.filter()

        XCTAssertFalse(result)
    }

    func test_filter_hasKeywordNoMatchingRegex_verifyResult() {
        let filter = KeywordRegexFilter(content: content, keyword: "Component", regex: Regex("blah"))

        let result = filter.filter()

        XCTAssertFalse(result)
    }

    func test_filter_hasKeywordMatchingRegex_verifyResult() {
        let filter = KeywordRegexFilter(content: content, keyword: "Component", regex: Regex(": *Component *<"))

        let result = filter.filter()

        XCTAssertTrue(result)
    }
}
