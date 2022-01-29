//
//  File.swift
//  See the Spread
//
//  Created by Yongqi Xu on 2022-01-28.
//

import SwiftUI

struct IndividualView: View {
    @ObservedObject var individual: Individual
    var body: some View {
        GeometryReader { proxy in
            Circle()
                .foregroundColor(colorForCondition(individual.healthCondition))
                .overlay(
                    Circle()
                        .stroke(.white.opacity(individual.isolationStatus == .isolated ? 0.5 : 0.0),
                                lineWidth: proxy.size.width / 4)
                )
        }
        .aspectRatio(1.0, contentMode: .fit)
    }
    
    private func colorForCondition(_ condition: Individual.HealthCondition) -> Color {
        switch condition {
        case .healthy:
            return Color("HealthyColor")
        case .infectedWithNoSymptoms:
            return Color("NoSymptomColor")
        case .infectedWithSymptoms:
            return Color("WithSymptomsColor")
        }
    }
}
