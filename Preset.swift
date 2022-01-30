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
    
    var id: String { self.rawValue }
    
    struct Info {
        let name: String
        let description: String
    }
    
    var info: Info {
        switch self {
        case .normal:
            return Info(name: "Normal", description: "This is the default preset. No one is vaccinated.")
        case .mostlyVaccinated:
            return Info(name: "Mostly Vaccinated",
                        description: "80% of the community will be vaccinated. See how much this would slow the spread down and reduce deaths.")
        }
    }
}
