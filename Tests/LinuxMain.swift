import XCTest

import TransactionTests

var tests = [XCTestCaseEntry]()
tests += TransactionTests.allTests()
XCTMain(tests)