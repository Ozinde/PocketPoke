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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        monitorNetwork()

        tableView.dataSource = self
        
        if searchCheck == false {
            pokemonName.text = name
            
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
            
            for item in info.stats {
                let statItem = Stats(name: item.stat.name, stat: item.number)
                self.pokeStats.append(statItem)
                
                print("Stat name: \(item.stat.name)")
                print("Stat number: \(item.number)")
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func noResult() {
        
        DispatchQueue.main.async {
            self.pokemonName.text = "No Results Found..."
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
