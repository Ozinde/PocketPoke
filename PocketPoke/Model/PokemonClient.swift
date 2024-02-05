//
//  PokemonClient.swift
//  PocketPoke
//
//  Created by Oneh Zinde on 2024/02/02.
//

import Foundation

class PokemonClient {
    
    //Enum that holds error cases
    enum RequestErrors: Error {
        case couldNotGetPokemon
        case couldNotGetPokemonResults
        case couldNotGetSearchData
        case couldNotFindSearchedResult
        case couldNotGetImageData
        case invalidURL
    }
    
    //Enum that holds various API endpoints
    enum EndPoints {
        
        static let base = "https://pokeapi.co/api/v2/pokemon/"
        
        case searchByName(String)
        case loadPokemonList(String)
        
        var stringValue: String {
            switch self {
            case .searchByName(let name):
                return EndPoints.base + "\(name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
            case .loadPokemonList(let limit):
                return EndPoints.base + "\(limit)"
            }
        }
        
        var url: URL? {
            return URL(string: stringValue)!
        }
    }
    
    /// Function used to obtain pokemon names and pagination parameters
    class func loadPokemon(limit: String) async throws -> PokeList {
        
        guard let request = EndPoints.loadPokemonList(limit).url else {
            throw RequestErrors.invalidURL
        }
        
        //URL is used to make a network request
        let (data, response) = try await URLSession.shared.data(from: request)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw RequestErrors.couldNotGetPokemon
        }
        
        do {
            // Data from the API is made available here
            let decoder = JSONDecoder()
            return try decoder.decode(PokeList.self, from: data)
        } catch {
            print("Error parsing weather data")
            throw RequestErrors.couldNotGetPokemonResults
        }
    }
    
    /// Function that provides pokemon name and image
    class func getPokeImage(name: String, completion: @escaping (Pokemon?, Error?) -> Void) {
        
        let request = URLRequest(url: EndPoints.searchByName(name).url!)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                completion(nil, RequestErrors.couldNotGetSearchData)
                print("No items")
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(Pokemon?.self, from: data)
                completion(responseObject, nil)
                
            } catch {
                completion(nil, RequestErrors.couldNotFindSearchedResult)
                print("Error: \(error)")
                print("Error getting searched pokemon")
                print(RequestErrors.couldNotFindSearchedResult)
            }
        }
        task.resume()
    }
    
    /// Function that uses image bytes to produce image for display
    class func requestImageFile(url: URL, completionHandler: @escaping (Data?, Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            guard let data = data else {
                print("No data")
                completionHandler(nil, RequestErrors.couldNotGetImageData)
                return
            }
            completionHandler(data, nil)
        })
        task.resume()
    }
    
    /// Function used to retrieve pokemon stats
    class func loadPokeInfo(name: String, completion: @escaping (PokeInfo?, Error?) -> Void) {
        
        let request = URLRequest(url: EndPoints.searchByName(name).url!)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                completion(nil, RequestErrors.couldNotGetPokemon)
                print("No items")
                return
            }
            
            let decoder = JSONDecoder()
            do {
                print("Info Found")
                let responseObject = try decoder.decode(PokeInfo.self, from: data)
                completion(responseObject, nil)
                
            } catch {
                completion(nil, RequestErrors.couldNotGetPokemonResults)
                print("Error getting results")
                print(RequestErrors.couldNotGetPokemonResults)
            }
        }
        task.resume()
    }
}
