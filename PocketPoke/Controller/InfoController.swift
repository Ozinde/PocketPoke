//
//  InfoController.swift
//  PocketPoke
//
//  Created by Oneh Zinde on 2024/02/02.
//

import UIKit

class InfoController: UIViewController {
    
    var name = String()
    var pokeImage: Data?
    var pokeStats = [Stats]()
    var searchCheck = true
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var pokemonName: UILabel!
    @IBOutlet var pokemonImage: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        monitorNetwork()
        loading(isLoading: true)

        tableView.dataSource = self
        
        if searchCheck == false {
            pokemonName.isHidden = false
            pokemonName.text = name.capitalized
            
            
            if let pokeImage = pokeImage {
                pokemonImage.image = UIImage(data: pokeImage)
            }
        }
        
        fetchPokeInfo()
    }
    
    func fetchPokeInfo() {
        PokemonClient.loadPokeInfo(name: name) { info, error in
            
            guard let info = info else {
                self.noResult()
                print("Error: \(error!)")
                return
            }
            
            if self.searchCheck == true {
                self.handleImageProcessing(imageURL: info.image.imageURL)
            }
            
            for item in info.stats {
                let statItem = Stats(name: item.stat.name, stat: item.number)
                self.pokeStats.append(statItem)
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.loading(isLoading: false)
                }
            }
        }
    }
    
    func noResult() {
        
        DispatchQueue.main.async {
            self.loading(isLoading: false)
            self.pokemonName.isHidden = false
            self.pokemonName.text = "No Results Found..."
            self.pokemonImage.image = UIImage(named: "no_result")
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
    
    func handleImageProcessing(imageURL: String) {
        guard let imageURL = URL(string: imageURL) else {
            print("No image data")
            showAlert(message: "Couldn't load image")
            return
        }
        PokemonClient.requestImageFile(url: imageURL) { data, error in
            guard let data = data else {
                return
            }
            
            DispatchQueue.main.async {
                self.pokemonName.isHidden = false
                self.pokemonName.text = self.name.capitalized
                self.pokemonImage.image = UIImage(data: data)
            }
        }
    }

}

extension InfoController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pokeStats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InfoCell") as! InfoViewCell
        
        let stat = pokeStats[indexPath.row]
        cell.statName.text = stat.name
        cell.statNumber.text = String(stat.stat)
        
        return cell
    }

}
