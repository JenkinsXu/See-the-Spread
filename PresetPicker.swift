//
//  File.swift
//  See the Spread
//
//  Created by Yongqi Xu on 2022-01-29.
//

import SwiftUI

struct PresetPicker: View {
    @Binding var preset: Preset
    @Environment(\.dismiss) var dismiss
    var body: some View {
        NavigationView {
            List {
                ForEach(Preset.allCases) { preset in
                    Button {
                        self.preset = preset
                        dismiss()
                    } label: {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(preset.info.name)
                                .font(.headline)
                            Text(preset.info.description)
                                .font(.caption)
                        }
                        .tint(.primary)
                    }

                }
            }
            .navigationTitle("Select a Preset")
        }
    }
}
