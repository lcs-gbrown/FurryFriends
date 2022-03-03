//
//  DogImage.swift
//  FurryFriends
//
//  Created by Gabi Brown on 2022-03-01.
//

import Foundation

struct DogImage: Decodable, Hashable, Encodable {
    // used hashable here because the id is not given by the JSON endpoint itself
    let message: String
    let status: String
}




