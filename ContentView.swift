import SwiftUI

struct ContentView: View {
    @StateObject var community = Community(row: 10, column: 10)
    var body: some View {
        VStack {
            CommunityView(community: community)
            Button("Next Day", action: community.moveOntoNextDay)
        }
    }
}

struct CommunityView: View {
    let community: Community
    var body: some View {
        VStack {
            ForEach(community.individuals.indices, id: \.self) { rowIndex in
                let row = community.individuals[rowIndex]
                HStack {
                    ForEach(row) { individual in
                        IndividualView(individual: individual)
                    }
                }
            }
        }
        .aspectRatio(1.0, contentMode: .fit)
        .padding()
    }
}
