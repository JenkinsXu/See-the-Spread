import SwiftUI

struct ContentView: View {
    @StateObject var community = Community(row: 3, column: 3)
    var body: some View {
        VStack {
            Text("Day \(community.daysIntoPandemic)")
                .font(.largeTitle)
                .bold()
            CommunityView(community: community)
            Button("Next Day") {
                community.moveOntoNextDay()
                community.individuals.forEach { row in
                    row.forEach { individual in
                        print(individual.healthCondition, terminator: " ")
                    }
                    print("")
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
            ForEach(community.individuals.flatMap { $0 }, id: \.id) { individual in
                IndividualView(individual: individual)
            }
        }
    }
}
