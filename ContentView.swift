import SwiftUI

struct ContentView: View {
    @StateObject var community = Community(row: 12, column: 8, r0: 2.0, preset: .mostlyVaccinated)
    var body: some View {
        VStack(spacing: 14) {
            Text("Day \(community.daysIntoPandemic)")
                .font(.largeTitle)
                .bold()
            CommunityView(community: community)
            VStack(spacing: 8) {
                HStack(spacing: 8) {
                    Button(action: community.moveOntoNextDay) {
                        Label("Next", systemImage: "calendar.badge.plus")
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .buttonBorderShape(.roundedRectangle)
                    Button(action: community.toggleAutoAdvance) {
                        if community.isAutoAdvancing {
                            Label("Pause", systemImage: "pause.fill")
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .foregroundColor(.accentColor)
                        } else {
                            Label("Auto", systemImage: "play.fill")
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .buttonBorderShape(.roundedRectangle)
                    .tint(community.isAutoAdvancing ? Color(uiColor: .secondarySystemFill) : .accentColor)
                    Button(action: community.reset) {
                        Label("Reset", systemImage: "backward.end.fill")
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .buttonBorderShape(.roundedRectangle)
                }
                HStack(spacing: 8) {
                    BottomSheetPresenter("Configure", imageSystemName: "gear", detents: [.medium(), .large()]) {
                        ConfigureView()
                    }
                    BottomSheetPresenter("Presets", imageSystemName: "circle.hexagongrid.fill", detents: [.medium(), .large()]) {
                        PresetPicker()
                    }
                }
            }
            .frame(maxHeight: 120)
        }
        .padding()
    }
}
