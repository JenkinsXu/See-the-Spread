import SwiftUI

struct ContentView: View {
    @StateObject var community = Community(row: 7, column: 5, r0: 2.0)
    var body: some View {
        VStack(spacing: 24) {
            Text("Day \(community.daysIntoPandemic)")
                .font(.largeTitle)
                .bold()
            CommunityView(community: community)
            GeometryReader { proxy in
                VStack(spacing: 8) {
                    Button(action: community.moveOntoNextDay) {
                        Label("Next Day", systemImage: "calendar.badge.plus")
                            .frame(width: proxy.size.width,
                                   height: (proxy.size.height - 8) / 2,
                                   alignment: .center)
                            .background(.blue.opacity(0.15))
                            .cornerRadius(6)
                    }
                    BottomSheetPresenter("Configure", detents: [.medium(), .large()]) {
                        ConfigureView()
                    }
                }
            }
        }
        .padding()
    }
}

struct CommunityView: View {
    @ObservedObject var community: Community
    var body: some View {
        let numberOfColumns = community.communitySize.column
        LazyVGrid(columns: Array(repeating: .init(.flexible(minimum: 1.0, maximum: 100.0)),
                                 count: numberOfColumns)) {
            ForEach(community.individuals.flatMap { $0 }) { individual in
                IndividualView(individual: individual)
            }
        }
    }
}
