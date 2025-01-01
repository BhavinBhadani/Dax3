//
//  FetchController.swift
//  Dax3
//
//  Created by Bhavin Bhadani on 28/12/24.
//

import Foundation
import CoreData

struct FetchController {
    enum NetworkError: Error {
        case badURL, badResponse, badData
    }
    
    private let baseURL = URL(string: "https://pokeapi.co/api/v2/pokemon")!
    
    func fetchAllPokemon() async throws -> [TempPokemon]? {
        if hasPokemon() {
            return nil
        }
        
        var pokemons: [TempPokemon] = []
        var fetchComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        fetchComponents?.queryItems = [.init(name: "limit", value: "386")]
        
        guard let fetchURL = fetchComponents?.url else {
            throw NetworkError.badURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: fetchURL)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw NetworkError.badResponse
        }
        
        guard let pokeDictionary = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
              let pokeDax = pokeDictionary["results"] as? [[String: String]] else {
            throw NetworkError.badData
        }
        
        for pokemon in pokeDax {
            if let urlString = pokemon["url"] {
                pokemons.append(try await fetchPokemon(from: URL(string: urlString)!))
            }
        }
        
        return pokemons
    }
    
    private func fetchPokemon(from url: URL) async throws -> TempPokemon {
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw NetworkError.badResponse
        }
        
        let decoder = JSONDecoder()
        return try decoder.decode(TempPokemon.self, from: data)
    }
    
    private func hasPokemon() -> Bool {
        let context = PersistenceController.shared.container.viewContext
        
        let request = Pokemon.fetchRequest()
        request.predicate = NSPredicate(format: "id IN %@", [1, 386])
        
        do {
            let checkPokemon = try context.fetch(request)
            return (checkPokemon.count == 2)
        } catch {
            print("Fetch failed: \(error.localizedDescription)")
            return false
        }
    }
}
