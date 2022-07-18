//
//  Data.swift
//  GitHub
//
//  Created by Dmitro Pechenenko on 17.07.2022.
//

import SwiftUI

struct Repositories: Decodable, Identifiable {
    var id: Int
    var name: String
    var html_url: String
}

