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
    }
    
    //Enum that holds various API endpoints
    enum EndPoints {
        
        static let base = "https://pokeapi.co/api/v2/pokemon/"
        
        case searchByName(String)
        case loadPokemonList
        
        var stringValue: String {
            switch self {
            case .searchByName(let name):
                return EndPoints.base + "name=\(name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
            case .loadPokemonList:
                return EndPoints.base + "?limit=2"
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    class func searchByName(name: String, completion: @escaping ([Pokemon], Error?) -> Void)-> URLSessionDataTask {
        
        var request = URLRequest(url: EndPoints.searchByName(name).url)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                completion([], RequestErrors.couldNotGetSearchData)
                print("No items")
                return
            }
            
            let decoder = JSONDecoder()
            do {
                print("Search went well")
                let responseObject = try decoder.decode([Pokemon].self, from: data)
                completion(responseObject, nil)
                
            } catch {
                completion([], RequestErrors.couldNotFindSearchedResult)
                print("Error getting searched cocktail")
                print(RequestErrors.couldNotFindSearchedResult)
            }
        }
        task.resume()
        return task
    }
    
    class func loadPokemon(name: String, completion: @escaping ([PokeList], Error?) -> Void)-> URLSessionDataTask {
        
        var request = URLRequest(url: EndPoints.loadPokemonList.url)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                completion([], RequestErrors.couldNotGetPokemon)
                print("No items")
                return
            }
            
            let decoder = JSONDecoder()
            do {
                print("Search went well")
                let responseObject = try decoder.decode([PokeList].self, from: data)
                completion(responseObject, nil)
                
            } catch {
                completion([], RequestErrors.couldNotGetPokemonResults)
                print("Error getting searched cocktail")
                print(RequestErrors.couldNotGetPokemonResults)
            }
        }
        task.resume()
        return task
    }
    
    class func loadPokeInfo(name: String, completion: @escaping ([PokeInfo], Error?) -> Void)-> URLSessionDataTask {
        
        var request = URLRequest(url: EndPoints.loadPokemonList.url)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                completion([], RequestErrors.couldNotGetPokemon)
                print("No items")
                return
            }
            
            let decoder = JSONDecoder()
            do {
                print("Search went well")
                let responseObject = try decoder.decode([PokeInfo].self, from: data)
                completion(responseObject, nil)
                
            } catch {
                completion([], RequestErrors.couldNotGetPokemonResults)
                print("Error getting searched cocktail")
                print(RequestErrors.couldNotGetPokemonResults)
            }
        }
        task.resume()
        return task
    }
}
