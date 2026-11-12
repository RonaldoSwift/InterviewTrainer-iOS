
import XCTest
import Home

@MainActor
final class HomeViewModelTests: XCTestCase {

    func testInitialState() {
        let viewModel = HomeViewModel()

        XCTAssertEqual(viewModel.title, "InterviewTrainer AI")
        XCTAssertEqual(
            viewModel.subtitle,
            "Prepárate para tu próxima entrevista técnica de iOS."
        )
        XCTAssertFalse(viewModel.isShowingPractice)
    }

    func testStartPracticeShowsPracticeState() {
        let viewModel = HomeViewModel()

        viewModel.startPractice()

        XCTAssertTrue(viewModel.isShowingPractice)
    }
}
