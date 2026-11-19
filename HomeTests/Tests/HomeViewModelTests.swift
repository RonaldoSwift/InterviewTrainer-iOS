
import XCTest
import Home

@MainActor
final class HomeViewModelTests: XCTestCase {

    func testInitialState() {
        let viewModel = HomeViewModel()

        XCTAssertEqual(viewModel.title, HomeStrings.Home.title)
        XCTAssertEqual(viewModel.subtitle, HomeStrings.Home.subtitle)
        XCTAssertFalse(viewModel.isShowingPractice)
    }

    func testStartPracticeShowsPracticeState() {
        let viewModel = HomeViewModel()

        viewModel.startPractice()

        XCTAssertTrue(viewModel.isShowingPractice)
    }
}
