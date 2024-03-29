//
//  Home.swift
//  GitHub
//
//  Created by Dmitro Pechenenko on 17.07.2022.
//

import SwiftUI

struct Home: View {
    
    @State var repoData = [Repositories]()
    @StateObject var viewModel: HomeViewModel = HomeViewModel()
    
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
                        Text("Come back later we can find more matches for you!")
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
            .padding(.top, 50)
            .padding()
            .padding(.vertical)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            HStack(spacing: 15) {
                Button {
                    doSwipe()
                } label: {
                    Image(systemName: "delete.left")
                        .font(.system(size: 25, weight: .bold))
                        .foregroundColor(.gray)
                        .shadow(radius: 5)
                        .padding(13)
                }
                Button {
                    doSwipe(rightSwipe: true)
                } label: {
                    Image(systemName: "suit.heart.fill")
                        .font(.system(size: 25, weight: .bold))
                        .foregroundColor(.red)
                        .shadow(radius: 5)
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
        Home()
    }
}

