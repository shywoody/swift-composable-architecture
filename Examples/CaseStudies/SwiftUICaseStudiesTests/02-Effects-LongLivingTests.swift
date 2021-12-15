import Combine
import ComposableArchitecture
import XCTest

@testable import SwiftUICaseStudies

class LongLivingEffectsTests: XCTestCase {
  func testReducer() {
    // A passthrough subject to simulate the screenshot notification
    let screenshotTaken = PassthroughSubject<Void, Never>()

    let store = TestStore(
      initialState: .init(),
      reducer: longLivingEffectsReducer,
      environment: .init(
        userDidTakeScreenshot: Effect(screenshotTaken)
      )
    )

    let task = store.send(.task)

    // Simulate a screenshot being taken
    screenshotTaken.send()
    store.receive(.userDidTakeScreenshotNotification) {
      $0.screenshotCount = 1
    }

    task.cancel()

    // Simulate a screenshot being taken to show no effects
    // are executed.
    screenshotTaken.send()
  }
}
