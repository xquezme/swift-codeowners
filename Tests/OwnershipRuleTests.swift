//
//  OwnershipRuleTests.swift
//
//
//  Created by Sergey Pimenov on 8/11/24.
//

@testable import swift_codeowners
import XCTest

// Tests based on: https://docs.gitlab.com/ee/user/project/codeowners/reference.html
final class OwnershipRuleTests: XCTestCase {
    func testRelativeGlob1() {
        let rule = OwnershipRulePattern(text: "README.md")
        XCTAssertEqual(rule, .glob(pattern: "**README.md"))
        XCTAssertTrue(try rule.match("/README.md"))
        XCTAssertTrue(try rule.match("/internal/README.md"))
        XCTAssertTrue(try rule.match("/app/lib/README.md"))
    }

    func testRelativeGlob2() {
        let rule = OwnershipRulePattern(text: "Source/**/*")
        XCTAssertEqual(rule, .glob(pattern: "**Source/**/*"))
    }

    func testAbsoluteGlob1() {
        let rule = OwnershipRulePattern(text: "/Source/*")
        XCTAssertEqual(rule, .glob(pattern: "/Source/*"))
    }

    func testAbsoluteGlob2() {
        let rule = OwnershipRulePattern(text: "/docs/index.*")
        XCTAssertEqual(rule, .glob(pattern: "/docs/index.*"))
        XCTAssertTrue(try rule.match("/docs/index.js"))
        XCTAssertTrue(try rule.match("/docs/index.html"))
    }

    func testAbsoluteGlob3() {
        let rule = OwnershipRulePattern(text: "/docs*/*index.*")
        XCTAssertEqual(rule, .glob(pattern: "/docs*/*index.*"))
        XCTAssertTrue(try rule.match("/docs/index.js"))
        XCTAssertTrue(try rule.match("/docs2/uindex.html"))
    }

    func testAbsoluteGlob4() {
        let rule = OwnershipRulePattern(text: "/docs/**/index.md")
        XCTAssertEqual(rule, .glob(pattern: "/docs/**/index.md"))
        XCTAssertTrue(try rule.match("/docs/index.md"))
        XCTAssertTrue(try rule.match("/docs/api/index.md"))
        XCTAssertTrue(try rule.match("/docs/api/graphql/index.md"))
    }

    func testAbsoluteFilePath1() {
        let rule = OwnershipRulePattern(text: "/README.md")
        XCTAssertEqual(rule, .absoluteFilePath(path: "/README.md"))
    }

    func testAbsoluteDirectoryPath1() throws {
        let rule = OwnershipRulePattern(text: "/docs/")
        XCTAssertEqual(rule, .absoluteDirectoryPath(path: "/docs/"))
        XCTAssertTrue(try rule.match("/docs/.gitignore"))
        XCTAssertTrue(try rule.match("/docs/README.md"))
        XCTAssertTrue(try rule.match("/docs/README"))
        XCTAssertTrue(try rule.match("/docs/nested/main.cpp"))
        XCTAssertTrue(try rule.match("/docs/nested/nested2/main"))
        XCTAssertFalse(try rule.match("/docs2/main.html"))
    }
}
