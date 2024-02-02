//
//  HomeController.swift
//  PocketPoke
//
//  Created by Oneh Zinde on 2024/02/02.
//

import UIKit

class HomeController: UIViewController {
    
    var pokemon = [Pokemon]()
    var selectedIndex = 0
    var filterNumber = Int()
    var currentSearchTask: URLSessionDataTask?
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()

        monitorNetwork()
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
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
        
        print("No drink filter applied")
        currentSearchTask = PokemonClient.searchByName(name: searchText) { [weak self] list, error in
            
            if list.isEmpty {
                if searchText.isEmpty {
                    self?.loading(isLoading: false)
                } else {
                    self?.loading(isLoading: true)
                }
                
            } else {
                self?.loading(isLoading: false)
            }
            
            self?.pokemon = list
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
            
        }
        
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
        return pokemon.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DrinkTableViewCell")!
        
        let pokemon = pokemon[indexPath.row]
        
        cell.textLabel?.text = pokemon.name.name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        performSegue(withIdentifier: "showResult", sender: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

