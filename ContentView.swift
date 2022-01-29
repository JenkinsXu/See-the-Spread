import SwiftUI

struct ContentView: View {
    @StateObject var community = Community(row: 7, column: 5, r0: 2.0)
    var body: some View {
        VStack(spacing: 14) {
            Text("Day \(community.daysIntoPandemic)")
                .font(.largeTitle)
                .bold()
            CommunityView(community: community)
            VStack(spacing: 8) {
                HStack(spacing: 8) {
                    Button(action: community.moveOntoNextDay) {
                        Label("Next Day", systemImage: "calendar.badge.plus")
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .buttonBorderShape(.roundedRectangle)
                    Button(action: community.toggleAutoAdvance) {
                        Label("Auto Advance", systemImage: "forward")
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .buttonBorderShape(.roundedRectangle)
                }
                BottomSheetPresenter("Configure", detents: [.medium(), .large()]) {
                    ConfigureView()
                }
            }
            .frame(maxHeight: 120)
        }
        .padding()
    }
}
