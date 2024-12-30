//
//  SamplePokemon.swift
//  Dax3
//
//  Created by Bhavin Bhadani on 30/12/24.
//

import Foundation
import CoreData

struct SamplePokemon {
    static let samplePokemon = {
        let context = PersistenceController.preview.container.viewContext
        
        let fecthRequest: NSFetchRequest<Pokemon> = Pokemon.fetchRequest()
        fecthRequest.fetchLimit = 1
        
        let results = try! context.fetch(fecthRequest)
        return results.first!
    }()
}
