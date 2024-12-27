//
//  Persistence.swift
//  Dax3
//
//  Created by Bhavin Bhadani on 25/12/24.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    @MainActor
    static let preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        let sample = Pokemon(context: viewContext)
        sample.id = 1
        sample.name = "bulbasaur"
        sample.types = ["grass", "poison"]
        sample.hp = 45
        sample.attack = 49
        sample.specialAttack = 65
        sample.specialDefense = 50
        sample.speed = 45
        sample.sprite = URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprite/pokemon/1.png")
        sample.shiny = URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprite/pokemon/shiny/1.png")
        sample.favorite = false
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Dax3")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
