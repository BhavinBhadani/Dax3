//
//  Stats.swift
//  Dax3
//
//  Created by Bhavin Bhadani on 31/12/24.
//

import SwiftUI
import Charts

struct Stats: View {
    @EnvironmentObject var pokemon: Pokemon
    
    var body: some View {
        Chart(pokemon.stats) { stat in
            BarMark(
                x: .value("Value", stat.value),
                y: .value("Stat", stat.label)
            )
            .annotation(position: .trailing) {
                Text("\(stat.value)")
                    .font(.caption)
                    .foregroundStyle(Color.secondary)
            }
        }
        .frame(height: 200)
        .padding([.leading, .trailing, .bottom])
        .foregroundStyle(Color(pokemon.types!.first!.capitalized))
        .chartXScale(domain: 0...pokemon.highestStat.value+10)
    }
}

#Preview {
    Stats()
        .environmentObject(SamplePokemon.samplePokemon)
}
