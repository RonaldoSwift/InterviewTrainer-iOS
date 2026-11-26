import Home
import Practice
import SwiftUI

struct AppRootView: View {
    @State private var isPracticePresented = false

    var body: some View {
        NavigationView {
            ZStack {
                HomeView {
                    isPracticePresented = true
                }

                NavigationLink(
                    destination: PracticeView(),
                    isActive: $isPracticePresented
                ) {
                    EmptyView()
                }
                .hidden()
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
