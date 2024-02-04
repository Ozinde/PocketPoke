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
    }
    
    //Enum that holds various API endpoints
    enum EndPoints {
        
        static let base = "https://pokeapi.co/api/v2/pokemon/"
        
        case searchByName(String)
        case loadPokemonList
        
        var stringValue: String {
            switch self {
            case .searchByName(let name):
                return EndPoints.base + "\(name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
            case .loadPokemonList:
                return EndPoints.base + "?limit=2"
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    class func loadPokemon(completion: @escaping (PokeList?, Error?) -> Void) {
        
        let request = URLRequest(url: EndPoints.loadPokemonList.url)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                completion(nil, RequestErrors.couldNotGetPokemon)
                print("No items")
                return
            }
            
            let decoder = JSONDecoder()
            do {
                print("Load went well")
                let responseObject = try decoder.decode(PokeList.self, from: data)
                completion(responseObject, nil)
                
            } catch {
                completion(nil, RequestErrors.couldNotGetPokemonResults)
                print("Error getting pokemon list")
                print("Error: \(error)")
                print(RequestErrors.couldNotGetPokemonResults)
            }
        }
        task.resume()
    }
    
    class func getPokeImage(name: String, completion: @escaping (Pokemon?, Error?) -> Void) {
        
        let request = URLRequest(url: EndPoints.searchByName(name).url)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                completion(nil, RequestErrors.couldNotGetSearchData)
                print("No items")
                return
            }
            
            let decoder = JSONDecoder()
            do {
                print("Search went well")
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
    
    class func searchPokemon(name: String, completion: @escaping (PokeList?, Error?) -> Void) -> URLSessionDataTask {
        
        let request = URLRequest(url: EndPoints.searchByName(name).url)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                completion(nil, RequestErrors.couldNotGetPokemon)
                print("No items")
                return
            }
            
            let decoder = JSONDecoder()
            do {
                print("Load went well")
                let responseObject = try decoder.decode(PokeList.self, from: data)
                completion(responseObject, nil)
                
            } catch {
                completion(nil, RequestErrors.couldNotGetPokemonResults)
                print("Error getting pokemon list")
                print("Error: \(error)")
                print(RequestErrors.couldNotGetPokemonResults)
            }
        }
        task.resume()
        return task
    }
    
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
    
    class func loadPokeInfo(name: String, completion: @escaping ([PokeInfo], Error?) -> Void) {
        
        let request = URLRequest(url: EndPoints.searchByName(name).url)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                completion([], RequestErrors.couldNotGetPokemon)
                print("No items")
                return
            }
            
            let decoder = JSONDecoder()
            do {
                print("Info Found")
                let responseObject = try decoder.decode([PokeInfo].self, from: data)
                completion(responseObject, nil)
                
            } catch {
                completion([], RequestErrors.couldNotGetPokemonResults)
                print("Error getting results")
                print(RequestErrors.couldNotGetPokemonResults)
            }
        }
        task.resume()
    }
}
