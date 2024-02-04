//
//  PokeInfo.swift
//  PocketPoke
//
//  Created by Oneh Zinde on 2024/02/02.
//

import Foundation

struct PokeInfo: Codable {
    let stats: [PokeStats]
}

struct PokeStats: Codable {
    let number: Int
    let stat: Stat
    
    enum CodingKeys: String, CodingKey {
        case number = "base_stat"
        case stat
    }
    
}

struct Stat: Codable {
    let name: String
}
