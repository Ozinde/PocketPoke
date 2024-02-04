//
//  HomeController.swift
//  PocketPoke
//
//  Created by Oneh Zinde on 2024/02/02.
//

import UIKit

class HomeController: UIViewController {
    
    var pokemon = [Pokemon]()
    var pokeItems = [PokeListItem]()
    var nextPage = String()
    var currentPage = 0
    var totalPages = 1
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        monitorNetwork()
        tableView.delegate = self
        tableView.dataSource = self
        
        loadListItems(requestString: "?limit=8")
    }
    
    func loadData(requestString: String) {
        // Make network call to fetch data for currentPage
        currentPage += 1
        totalPages += 1
        loadListItems(requestString: requestString)
    }
    
    func handleImageProcessing(name: String, imageURL: String, error: Error?) {
        guard let imageURL = URL(string: imageURL) else {
            print(error?.localizedDescription ?? "No image data")
            showFailure(message: error?.localizedDescription ?? "")
            return
        }
        PokemonClient.requestImageFile(url: imageURL) { data, error in
            guard let data = data else {
                return
            }
            
            let item = PokeListItem(name: name, image: data)
            self.pokeItems.append(item)
            
            print("items: \(self.pokeItems.count)")
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func loadListItems(requestString: String) {
        PokemonClient.loadPokemon(limit: requestString) { pokeList, error in
            
            guard let pokeList = pokeList else {
                print("Error: \(error!)")
                return
            }
            
            self.nextPage = self.limitString(url: pokeList.next)
            print("Page: \(self.nextPage)")
            
            for item in pokeList.results {
                PokemonClient.getPokeImage(name: item.name) { pokemon, error in
                    guard let pokemon = pokemon else {
                        print("Error: \(error!)")
                        return
                    }
                    
                    self.handleImageProcessing(name: item.name, imageURL: pokemon.image.imageURL, error: error)
                }
            }
        }
    }
    
    func limitString(url: String) -> String {
        let start = url.startIndex
        let limit = url.index(start, offsetBy: 34)
        let end = url.index(before: url.endIndex)
        let range = limit...end
        let finalString = url[range]
        return String(finalString)
    }
    

}



extension HomeController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pokeItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell") as! PokeTableViewCell
        
        let pokemon = pokeItems[indexPath.row]
        
        cell.pokemonName.text = pokemon.name
        cell.setupImage(data: pokemon.image)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == pokeItems.count - 1, currentPage < totalPages, pokeItems.count < 40 {
            loadData(requestString: nextPage)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        selectedIndex = indexPath.row
        performSegue(withIdentifier: "showInfo", sender: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }

}

