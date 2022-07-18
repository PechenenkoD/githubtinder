//
//  Home.swift
//  GitHub
//
//  Created by Dmitro Pechenenko on 17.07.2022.
//

import SwiftUI

struct Repository: View {
    
    @State var repoData = [Repositories]()
    @StateObject var viewModel: RepositoryViewModel = RepositoryViewModel()
    
    var body: some View {
        
        VStack {
            
            Button {
                
            } label: {
                Image(systemName: "folder")
                    .resizable()
                    .renderingMode(.template)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 22, height: 22)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .overlay(
                Text("Repositories")
                    .font(.title.bold())
            )
            
            
            .foregroundColor(.black)
            .padding()
            
            ZStack {
                if let repositories = viewModel.displaying_repositories {
                    if repositories.isEmpty {
                        Text("Oops! That's all!")
                            .font(.caption)
                            .foregroundColor(.gray)
                    } else {
                            ForEach(repositories.reversed()) { repository in
                                StackCardView(repository: repository)
                                    .environmentObject(viewModel)
                            }
                    }
                } else {
                    ProgressView()
                }
            }
            .padding(.top, 80)
            .padding()
            .padding(.vertical)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            HStack(spacing: 15) {
                Button {
                    doSwipe()
                } label: {
                    Image(systemName: "delete.left")
                        .font(.system(size: 30, weight: .bold))
                        .foregroundColor(.gray)
                        .padding(13)
                }
                Button {
                    doSwipe(rightSwipe: true)
                } label: {
                    Image(systemName: "heart.fill")
                        .font(.system(size: 30, weight: .bold))
                        .foregroundColor(.red)
                        .padding(13)
                }
            }
            .padding(.bottom)
            .disabled(viewModel.displaying_repositories?.isEmpty ?? false)
            .opacity((viewModel.displaying_repositories?.isEmpty ?? false) ? 0.6 : 1)
        }
        .onAppear() {
            viewModel.fetchData()
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }
    
    func doSwipe(rightSwipe: Bool = false) {
        guard let first = viewModel.displaying_repositories?.first else {
            return
        }
        NotificationCenter.default.post(name: NSNotification.Name("ACTIONFROMBUTTON"), object: nil, userInfo: [
            "id": first.id,
            "rightSwipe": rightSwipe
        ])
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Repository()
    }
}

