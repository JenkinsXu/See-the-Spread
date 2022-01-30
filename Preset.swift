//
//  File.swift
//  See the Spread
//
//  Created by Yongqi Xu on 2022-01-29.
//

import Foundation

enum Preset: String, CaseIterable, Identifiable {
    case normal
    case mostlyVaccinated
    case rarelyVaccinated
    case rarelyFullyVaccinated
    
    var id: String { self.rawValue }
    
    struct Info {
        let name: String
        let description: String
    }
    
    var info: Info {
        switch self {
        case .normal:
            return Info(name: "None Vaccinated", description: "No one is vaccinated. Notice how fast the virus will be spreading.")
        case .mostlyVaccinated:
            return Info(name: "Mostly Vaccinated",
                        description: "80% of the community will be vaccinated by one dose. See how much this would slow the spread down and reduce deaths.")
        case .rarelyVaccinated:
            return Info(name: "Rarely Vaccinated",
                        description: "Only 30% of the community will be vaccinated by one dose. Compare the result with higher or lower vaccination rate.")
        case .rarelyFullyVaccinated:
            return Info(name: "Rarely Fully Vaccinated", description: "30% of the people will get the first available dose, and then 30% of all people will get the second available dose. This results in some people getting 2 doses in total.")
        }
    }
}
