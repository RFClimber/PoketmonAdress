//
//  PokeFile.swift
//  PoketmonAdress
//
//  Created by mac on 7/16/24.
//

import Foundation

struct PokeFile: Codable {
    let id: Int
    let name: String
    let sprites: Sprites
    
    struct Sprites: Codable {
        let front_default: String
    }
}
