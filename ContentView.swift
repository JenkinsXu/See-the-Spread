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
                Button(action: community.moveOntoNextDay) {
                    Label("Next Day", systemImage: "calendar.badge.plus")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.roundedRectangle)
                BottomSheetPresenter("Configure", detents: [.medium(), .large()]) {
                    ConfigureView()
                }
            }
            .frame(maxHeight: 120)
        }
        .padding()
    }
}

struct CommunityView: View {
    @ObservedObject var community: Community
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
    }
}
