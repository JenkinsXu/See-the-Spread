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

class Community: ObservableObject {
    struct CommunityIndex {
        let row: Int
        let column: Int
    }
    typealias CommunitySize = CommunityIndex
    
    @Published var individuals: [[Individual]]
    @Published var daysIntoPandemic = 0
    @Published var isAutoAdvancing = false
    let communitySize: CommunitySize
    var r0: Double
    private var isUsingMostlyVaccinatedPreset = false
    
    init(row: Int, column: Int, r0: Double = 1.0) {
        self.communitySize = CommunitySize(row: row, column: column)
        self.individuals = (0..<row).map { _ in
            (0..<column).map { _ in
                Individual()
            }
        }
        self.r0 = r0
        self.firstPatientOccurs()
    }
    
    static func mostlyVaccinated(row: Int, column: Int, r0: Double = 1.0) -> Community {
        let community = Community(row: row, column: column, r0: r0)
        community.vaccinateMostPeople()
        community.firstPatientOccurs()
        community.isUsingMostlyVaccinatedPreset = true
        return community
    }
    
    private func vaccinateMostPeople() {
        individuals.flatMap { $0 }.forEach { individual in
            if Double.random(in: 0.0...1.0) < 0.8 {
                individual.vaccinated()
            }
        }
    }
    
    private func firstPatientOccurs() {
        individuals
            .randomElement()?
            .randomElement()?
            .infected(showingSymptoms: false)
    }
    
    @Sendable
    func moveOntoNextDay() {
        daysIntoPandemic += 1
        spread()
    }
    
    func toggleAutoAdvance() {
        isAutoAdvancing.toggle()
        autoAdvance()
    }
    
    private func autoAdvance() {
        Task {
            guard isAutoAdvancing else { return }
            await MainActor.run(body: moveOntoNextDay)
            try? await Task.sleep(nanoseconds: 1_000_000_000)
            autoAdvance()
        }
    }
    
    private func spread() {
        let infectedIndices = individuals
            .enumerated()
            .flatMap { (rowIndex, row) -> [CommunityIndex] in
                let infectedColumnsAtRow = row
                    .enumerated()
                    .compactMap { columnIndex, individual in
                        individual.isInfected ? columnIndex : nil
                    }
                return infectedColumnsAtRow.map { CommunityIndex(row: rowIndex, column: $0) }
            }
        let infecterAndContactedIndividuals = infectedIndices.map {(
            infecter: individual(at: $0),
            contactedIndividuals: individualsAround(index: $0)
        )}
        infecterAndContactedIndividuals.forEach {
            guard let infecter = $0.infecter else { return }
            let contactedIndividuals = $0.contactedIndividuals.shuffled()
            
            infecter.numberOfDaysAfterInfected += 1
            infecter.recoverOrRemoved()
            
            var contactedIndividualIterator = contactedIndividuals.makeIterator()
            while infecter.canInfectOthers(communityR0: r0),
                  let contactedIndividual = contactedIndividualIterator.next() {
                let infected = contactedIndividual.makeContact()
                infecter.spreadCount += infected ? 1 : 0
            }
        }
    }
    
    private func individual(at index: CommunityIndex) -> Individual? {
        guard
            (index.row    < communitySize.row) &&
            (index.column < communitySize.column) &&
            (index.row    >= 0) &&
            (index.column >= 0)
        else {
            return nil
        }
        return individuals[index.row][index.column]
    }
    
    private func individualsAround(index: CommunityIndex) -> [Individual] {
        let indices = [CommunityIndex(row: index.row - 1, column: index.column),
                       CommunityIndex(row: index.row, column: index.column - 1),
                       CommunityIndex(row: index.row, column: index.column + 1),
                       CommunityIndex(row: index.row + 1, column: index.column)
        ]
        return indices.compactMap { individual(at: $0) }
    }
    
    func reset() {
        daysIntoPandemic = 0
        individuals = (0..<communitySize.row).map { _ in
            (0..<communitySize.column).map { _ in
                Individual()
            }
        }
        if isUsingMostlyVaccinatedPreset {
            vaccinateMostPeople()
        }
        firstPatientOccurs()
    }
}
