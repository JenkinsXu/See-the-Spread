//
//  File.swift
//  See the Spread
//
//  Created by Yongqi Xu on 2022-01-29.
//

import SwiftUI

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
