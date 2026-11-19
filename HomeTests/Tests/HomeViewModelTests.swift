
import XCTest
import Home

@MainActor
final class HomeViewModelTests: XCTestCase {

    func testInitialState() {
        let viewModel = HomeViewModel()

        XCTAssertEqual(viewModel.title, HomeLocalization.title)
        XCTAssertEqual(viewModel.subtitle, HomeLocalization.subtitle)
        XCTAssertFalse(viewModel.isShowingPractice)
    }

    func testStartPracticeShowsPracticeState() {
        let viewModel = HomeViewModel()

        viewModel.startPractice()

        XCTAssertTrue(viewModel.isShowingPractice)
    }
}
