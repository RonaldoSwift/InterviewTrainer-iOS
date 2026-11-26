import XCTest
@testable import Home

final class HomeViewModelTests: XCTestCase {
    func testStartPracticeInvokesTheProvidedAction() {
        var didStartPractice = false
        let viewModel = HomeViewModel {
            didStartPractice = true
        }

        viewModel.startPractice()

        XCTAssertTrue(didStartPractice)
    }
}
