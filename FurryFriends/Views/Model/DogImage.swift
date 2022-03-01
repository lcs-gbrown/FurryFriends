//
//  model.swift
//  FurryFriends
//
//  Created by gabi brown on 2022-03-01.
//

import Foundation

//Define JSON file
struct DogImage: Decodable, Hashable {
    let id: String
    let message: String
    let status: String
}
