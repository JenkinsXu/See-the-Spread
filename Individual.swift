//
//  File.swift
//  See the Spread
//
//  Created by Yongqi Xu on 2022-01-28.
//

import Foundation

class Individual: Identifiable, ObservableObject {
    enum HealthCondition {
        case normal
        case vaccinated
        case infectedWithSymptoms
        case infectedWithNoSymptoms
        case removed
    }
    
    enum IsolationStatus {
        case isolated
        case nonisolated
    }
    
    @Published var healthCondition: HealthCondition = .normal
    @Published var isolationStatus: IsolationStatus = .nonisolated
    var spreadCount = 0
    var possibilityOfGettingInfected = Double.random(in: 0.5...0.8)
    var numberOfDaysAfterInfected = 0
    var hasBeenVaccinated = false
    let id = UUID()
    var isInfected: Bool {
        healthCondition == .infectedWithSymptoms || healthCondition == .infectedWithNoSymptoms
    }
    
    func canInfectOthers(communityR0: Double) -> Bool {
        (isolationStatus != .isolated) &&
        (Double(spreadCount) + 1 <= communityR0) &&
        (healthCondition == .infectedWithNoSymptoms || healthCondition == .infectedWithSymptoms)
    }
    
    func infected(showingSymptoms: Bool) {
        healthCondition = showingSymptoms ?
            .infectedWithSymptoms :
            .infectedWithNoSymptoms
    }
    
    func recoverOrRemoved() {
        if numberOfDaysAfterInfected > 30 {
            if hasBeenVaccinated && (Double.random(in: 0.0...1.0) < 0.5) {
                healthCondition = .removed
            } else {
                healthCondition = .removed
            }
        } else if Double.random(in: 0.0...1.0) < 0.05 {
            healthCondition = hasBeenVaccinated ? .vaccinated : .normal
            isolationStatus = .nonisolated
            increaseImmunibility(by: 0.2)
            numberOfDaysAfterInfected = 0
        }
    }
    
    func vaccinated() {
        healthCondition = .vaccinated
        hasBeenVaccinated = true
        isolationStatus = .nonisolated
        increaseImmunibility(by: 0.4)
    }
    
    private func increaseImmunibility(by amount: Double) {
        guard (possibilityOfGettingInfected - amount) >= 0 else {
            possibilityOfGettingInfected = 0
            return
        }
        possibilityOfGettingInfected -= amount
    }
    
    func makeContact() -> Bool {
        guard
            isolationStatus == .nonisolated,
            (healthCondition != .infectedWithSymptoms) && (healthCondition != .infectedWithNoSymptoms),
            Double.random(in: 0.0...1.0) < possibilityOfGettingInfected
        else {
            return false
        }
        
        infected(showingSymptoms: Bool.random())
        return true
    }
}
