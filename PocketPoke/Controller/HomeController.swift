//
//  HomeController.swift
//  PocketPoke
//
//  Created by Oneh Zinde on 2024/02/02.
//

import UIKit

class HomeController: UIViewController {
    
    /// Variables
    var pokemon = [Pokemon]()
    var pokeItems = [PokeListItem]()
    var nextPage = String()
    var searchText = String()
    var currentPage = 0
    var totalPages = 1
    var selectedIndex = 0
    
    /// Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: Lifecycle Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()

        monitorNetwork()
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        
        loadListItems(requestString: "?limit=10")
    }
    
    // MARK: Functions
    
    /// Function that fetches paginated list items
    fileprivate func loadData(requestString: String) {
        // Make network call to fetch data for currentPage
        currentPage += 1
        totalPages += 1
        loadListItems(requestString: requestString)
    }
    
    /// Function that fetches pokemon list items
    fileprivate func loadListItems(requestString: String) {
        PokemonClient.loadPokemon(limit: requestString) { pokeList, error in
            
            guard let pokeList = pokeList else {
                print("Error with list items")
                return
            }
            
            self.nextPage = self.limitString(url: pokeList.next)
            print("Page: \(self.nextPage)")
            
            for item in pokeList.results {
                PokemonClient.getPokeImage(name: item.name) { pokemon, error in
                    guard let pokemon = pokemon else {
                        print("Error with item names")
                        return
                    }
                    
                    self.handleImageProcessing(name: item.name, imageURL: pokemon.image.imageURL, error: error)
                }
            }
        }
    }
    
    /// Function that uses image URL to download image bytes
    fileprivate func handleImageProcessing(name: String, imageURL: String, error: Error?) {
        guard let imageURL = URL(string: imageURL) else {
            print(error?.localizedDescription ?? "No image data")
            showAlert(message: error?.localizedDescription ?? "")
            return
        }
        PokemonClient.requestImageFile(url: imageURL) { data, error in
            guard let data = data else {
                return
            }
            
            let item = PokeListItem(name: name, image: data)
            self.pokeItems.append(item)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    
    /// Function used to find pagination parameters
    fileprivate func limitString(url: String) -> String {
        let start = url.startIndex
        let limit = url.index(start, offsetBy: 34)
        let end = url.index(before: url.endIndex)
        let range = limit...end
        let finalString = url[range]
        return String(finalString)
    }
    

}

// MARK: TableView Methods

extension HomeController: UITableViewDataSource, UITableViewDelegate {
    
    /// Determine number of items table view should display
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pokeItems.count
    }
    
    /// Configure each table view cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell") as! PokeTableViewCell
        
        let pokemon = pokeItems[indexPath.row]
        
        cell.pokemonName.text = pokemon.name.capitalized
        cell.setupImage(data: pokemon.image)
        
        return cell
    }
    
    /// Method used to fetch next batch of items
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.row == pokeItems.count - 1, currentPage < totalPages, pokeItems.count < 100, !nextPage.contains(find: "100") {
            loadData(requestString: nextPage)
        }
    }
    
    /// Respond to taps on the table view's cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        openVibe()
        performSegue(withIdentifier: "showInfo", sender: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    /// Method used to share variables with InfoController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showInfo":
            //Get the item associated with this row and pass it along
            let pokemon = pokeItems[selectedIndex]
            let vc = segue.destination as! InfoController
            vc.name = pokemon.name
            vc.pokeImage = pokemon.image
            vc.searchCheck = false
        case "showSearch":
            let vc = segue.destination as! InfoController
            vc.name = searchText.lowercased()
            
        default:
            print("Unexpected segue identifier")
            showAlert(message: "Please restart your app")
        }
    }


}

// MARK: Searchbar Protocol Methods

extension HomeController: UISearchBarDelegate {
    
    /// Function used to perform segue
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text {
            searchText = text
            performSegue(withIdentifier: "showSearch", sender: nil)
        }
    }
    
    /// Handles editing functionality
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    /// Handles editing functionality
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
    }
    
    /// Handles editing functionality
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
}

