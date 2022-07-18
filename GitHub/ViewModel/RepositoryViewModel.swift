//
//  HomeViewModel.swift
//  GitHub
//
//  Created by Dmitro Pechenenko on 17.07.2022.
//

import SwiftUI

enum Defaults {
    static let numberZero = 0
    static let url = "https://api.github.com/repositories"
}

class RepositoryViewModel: ObservableObject {

    @Published var fetched_repositories: [Repositories] = []
    @Published var displaying_repositories: [Repositories]?
    
    init() {
        fetched_repositories = []
        displaying_repositories = fetched_repositories
    }
    
    func getIndex(repository: Repositories) -> Int {
        let index = displaying_repositories?.firstIndex(where: { currentRepo in
            return repository.id == currentRepo.id
        }) ?? Defaults.numberZero
        return index
    }
    
    func fetchData() {
        guard let url = URL(string: Defaults.url) else { return }
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else { return }
            
            do {
                let repositories = try JSONDecoder().decode([Repositories].self, from: data)
                DispatchQueue.main.async {
                    self.displaying_repositories = repositories
                }
            } catch {
                print(error)
            }
        }
        task.resume()
    }
}
