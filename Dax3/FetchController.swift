//
//  FetchController.swift
//  Dax3
//
//  Created by Bhavin Bhadani on 28/12/24.
//

import Foundation

struct FetchController {
    enum NetworkError: Error {
        case badURL, badResponse, badData
    }
    
    private let baseURL = URL(string: "https://pokeapi.co/api/v2/pokemon")!
    
    func fetchAllPokemon() async throws -> [TempPokemon] {
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
}
