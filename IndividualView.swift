//
//  File.swift
//  See the Spread
//
//  Created by Yongqi Xu on 2022-01-28.
//

import SwiftUI

struct IndividualView: View {
    @ObservedObject var individual: Individual
    
    private var possibilityOfGettingInfectedInPercentage: String {
        NumberFormatter.localizedString(from: NSNumber(value: individual.possibilityOfGettingInfected),
                                        number: .percent)
    }
    
    var body: some View {
        ZStack {
            GeometryReader { proxy in
                Circle()
                    .foregroundColor(colorForCondition(individual.healthCondition))
                    .overlay(
                        Circle()
                            .stroke(.white.opacity(individual.isolationStatus == .isolated ? 0.5 : 0.0),
                                    lineWidth: proxy.size.width / 4)
                    )
                    .onTapGesture {
                        withAnimation {
                            individual.vaccinated()
                        }
                    }
            }
            .aspectRatio(1.0, contentMode: .fit)
            
            Text(possibilityOfGettingInfectedInPercentage)
                .font(.caption)
                .foregroundColor(.white)
        }
    }
    
    private func colorForCondition(_ condition: Individual.HealthCondition) -> Color {
        switch condition {
        case .normal:
            return Color("NormalColor")
        case .vaccinated:
            return Color("VaccinatedColor")
        case .infectedWithNoSymptoms:
            return Color("NoSymptomColor")
        case .infectedWithSymptoms:
            return Color("WithSymptomsColor")
        case .removed:
            return .secondary
        }
    }
}
