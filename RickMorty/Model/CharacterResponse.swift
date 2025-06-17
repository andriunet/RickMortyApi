//
//  CharacterResponse.swift
//  RickMorty
//
//  Created by Andres on 16/06/25.
//

import Foundation

struct CharacterResponse: Codable {
    let info: PaginationInfo
    let results: [Character]
}

struct PaginationInfo: Codable {
    let next: String?
}

struct Character: Identifiable, Codable {
    var id: Int
    var name: String
    var status: String
    var species: String
    var created: String
    var gender: String
    var image: String
    var origin: Location
    var location: Location
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case status
        case species
        case created
        case gender
        case image
        case origin
        case location
    }
}

struct Location: Codable {
    var name: String
}
