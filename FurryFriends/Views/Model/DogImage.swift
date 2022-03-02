//
//  DogImage.swift
//  FurryFriends
//
//  Created by Gabi Brown on 2022-03-01.
//

import Foundation

struct DogImage: Decodable, Hashable, Encodable {
    // defined the id here because the id is not given by the JSON endpoint itself
    var id = UUID()
    let message: String
    let status: String
}
