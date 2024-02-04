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
    var selectedIndex = 0
    var filterNumber = Int()
    var currentSearchTask: URLSessionDataTask?
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        PokemonClient.loadPokemon { pokeList, error in
            
            guard let pokeList = pokeList else {
                print("Error: \(error!)")
                return
            }
            
            for item in pokeList.results {
                PokemonClient.getPokeImage(name: item.name) { pokemon, error in
                    guard let pokemon = pokemon else {
                        print("Error: \(error!)")
                        return
                    }

                    print("A")
                    self.handleImageProcessing(name: item.name, imageURL: pokemon.image.imageURL, error: error)
                }
            }
            
        }

        monitorNetwork()
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
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
    
    func loading(isLoading: Bool) {
        if isLoading {
            DispatchQueue.main.async {
                self.tableView.isHidden = true
                self.activityIndicator.isHidden = false
                self.activityIndicator.startAnimating()
            }
            
        } else {
            DispatchQueue.main.async {
                self.tableView.isHidden = false
                self.activityIndicator.isHidden = true
                self.activityIndicator.stopAnimating()
            }
        }
    }
    

}

extension HomeController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("text change")
        currentSearchTask?.cancel()
        
        currentSearchTask = PokemonClient.searchPokemon(name: searchText, completion: { [weak self] nameText, error in
            
            guard let nameText = nameText else {
                print("Error: \(error!)")
                return
            }
            
            if nameText.results.isEmpty {
                if searchText.isEmpty {
                    self?.loading(isLoading: false)
                } else {
                    self?.loading(isLoading: true)
                }
                
            } else {
                self?.loading(isLoading: false)
            }
            
            for item in nameText.results {
                
                let pokemon = PokeListItem(name: item.name, image: nil)
                self?.pokeItems.append(pokemon)
            }
            
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
            
        })
        
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        performSegue(withIdentifier: "showInfo", sender: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

