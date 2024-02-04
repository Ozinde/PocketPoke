//
//  PokeTableViewCell.swift
//  PocketPoke
//
//  Created by Oneh Zinde on 2024/02/04.
//

import UIKit

class PokeTableViewCell: UITableViewCell {

    @IBOutlet weak var pokemonName: UILabel!
    @IBOutlet var pokemonImage: UIImageView!
    
    func setupImage(data: Data?) {
        if let data = data {
            let image = UIImage(data: data)
            pokemonImage.image = image
        }
    }
    
    func setupText(row: Int) {
        if row % 4 == 0 {
            pokemonName.textColor = .red
        }
    }

}
