import SwiftUI

struct ContentView: View {
    @StateObject var community = Community(row: 7, column: 5, r0: 2.0)
    var body: some View {
        VStack(spacing: 16) {
            Text("Day \(community.daysIntoPandemic)")
                .font(.largeTitle)
                .bold()
            CommunityView(community: community)
            Button("Next Day", action: community.moveOntoNextDay)
                .buttonStyle(.bordered)
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
            ForEach(community.individuals.flatMap { $0 }, id: \.id) { individual in
                IndividualView(individual: individual)
            }
        }
    }
}
