//
//  Detail.swift
//  GitHub
//
//  Created by Dmitro Pechenenko on 19.07.2022.
//

import SwiftUI

struct Favorites: View {
    
    let favoritesRepositories = ["repo", "repo1", "repo2"]
    
    var body: some View {
        NavigationView {
            List {
                ForEach(favoritesRepositories, id: \.self) { repo in
                    Text(repo)
                }
            }
            .navigationTitle("Favorites")
        }
    }
}

struct Detail_Previews: PreviewProvider {
    static var previews: some View {
        Favorites()
    }
}
