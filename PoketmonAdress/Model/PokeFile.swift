//
//  PokeFile.swift
//  PoketmonAdress
//
//  Created by mac on 7/16/24.
//

import Foundation

struct PokeFile: Codable {
    let poketmon: [Poketmon]
}

struct Poketmon: Codable {
    let id: Int
    let name: String
    let height: Int
    let weight: Int
    let sprites: [String]
}
