//
//  File.swift
//  See the Spread
//
//  Created by Yongqi Xu on 2022-01-28.
//

import Foundation

class Individual {
    enum HealthCondition {
        case healthy
        case infectedWithSymptoms
        case infectedWithNoSymptoms
    }
    
    enum IsolationStatus {
        case isolated
        case nonisolated
    }
    
    var healthCondition: HealthCondition = .healthy
    var isolationStatus: IsolationStatus = .nonisolated
    var spreadCount = 0
    private var possibilityOfGettingInfected = Double.random(in: 0.5...0.8)
    
    func canInfectOthers(communityR0: Double) -> Bool {
        (isolationStatus != .isolated) && (Double(spreadCount) <= communityR0)
    }
    
    private func infected(showingSymptoms: Bool) {
        healthCondition = showingSymptoms ?
            .infectedWithSymptoms :
            .infectedWithNoSymptoms
    }
    
    // TODO: cure/remove an individual after a certain time
    func cured() {
        healthCondition = .healthy
        isolationStatus = .nonisolated
        increaseImmunibility(by: 0.3)
    }
    
    func vaccinated() {
        isolationStatus = .nonisolated
        increaseImmunibility(by: 0.7)
    }
    
    private func increaseImmunibility(by amount: Double) {
        guard (possibilityOfGettingInfected - amount) >= 0 else {
            possibilityOfGettingInfected = 0
            return
        }
        possibilityOfGettingInfected -= amount
    }
    
    func makeContact() {
        guard
            isolationStatus == .nonisolated,
            Double.random(in: 0.0...1.0) < possibilityOfGettingInfected
        else {
            return
        }
        
        infected(showingSymptoms: Bool.random())
    }
}

class Community: ObservableObject {
    struct CommunityIndex {
        let row: Int
        let column: Int
    }
    typealias CommunitySize = CommunityIndex
    
    @Published var individuals: [[Individual]]
    let communitySize: CommunitySize
    var r0: Double
    var daysIntoPandemic = 0
    
    init(row: Int, column: Int, r0: Double = 1.0) {
        self.communitySize = CommunitySize(row: row, column: column)
        self.individuals = Array(repeating: Array(repeating: Individual(),
                                                  count: column),
                                 count: row)
        self.r0 = r0
    }
    
    func moveOntoNextDay() {
        daysIntoPandemic += 1
        spread()
    }
    
    private func spread() {
        let infectedIndices = individuals
            .enumerated()
            .flatMap { (rowIndex, row) -> [CommunityIndex] in
                let infectedColumnsAtRow = row
                    .enumerated()
                    .compactMap { columnIndex, individual in
                        individual.canInfectOthers(communityR0: r0) ? columnIndex : nil
                    }
                return infectedColumnsAtRow.map { CommunityIndex(row: rowIndex, column: $0) }
            }
        let contactedPeople = infectedIndices.flatMap { individualsAround(index: $0) }
        contactedPeople.forEach { $0.makeContact() }
    }
    
    private func individual(at index: CommunityIndex) -> Individual? {
        guard
            (index.row    < communitySize.row) &&
            (index.column < communitySize.column)
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
}
