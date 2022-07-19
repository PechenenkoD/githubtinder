//
//  StackCardView.swift
//  GitHub
//
//  Created by Dmitro Pechenenko on 17.07.2022.
//

import SwiftUI

struct StackCardView: View {
    
    @EnvironmentObject var viewModel: RepositoryViewModel
    @State var repository: Repositories
    @State var offset: CGFloat = 0
    @GestureState var isDragging: Bool = false
    @State var endSwipe: Bool = false
    @State var repoData = [Repositories]()
    
    var body: some View {
        
        GeometryReader {proxy in
            let size = proxy.size
            let index = CGFloat(viewModel.getIndex(repository: repository))
            let topOffset = (index <= 2 ? index : 3) * 15
            
            ZStack {
                Image("")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size.width - topOffset, height: size.height)
                    .background(.orange)
                    .border(Color.gray, width: 1)
                    .cornerRadius(15)
                    .offset(y: -topOffset)
                
                VStack {
                    VStack(alignment: .leading) {
                        Text(repository.name).font(.largeTitle).fontWeight(.bold)
                        Text(repository.html_url)
                    }
                }.padding()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        }
        .offset(x: offset)
        .rotationEffect(.init(degrees: getRotation(angle: 8)))
        .contentShape(Rectangle().trim(from: 0, to: endSwipe ? 0 : 1))
        .gesture(
            DragGesture()
                .updating($isDragging, body: { value, out, _ in
                    out = true
                })
                .onChanged({ value in
                    let translation  = value.translation.width
                    offset = (isDragging ? translation : .zero)
                })
                .onEnded({ value in
                    let width = getRect().width - 50
                    let translation = value.translation.width
                    let checkingStatus = (translation > 0 ? translation : -translation)
                    
                    withAnimation {
                        if checkingStatus > (width / 2) {
                            offset = (translation > 0 ? width : -width) * 2
                            endSwipeActions()
                            if translation > 0 {
                                rightSwipe()
                            } else {
                                leftSwipe()
                            }
                        } else {
                            offset = .zero
                        }
                    }
                })
        )
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("ACTIONFROMBUTTON"), object: nil)) { data in
            
            guard let info = data.userInfo else {
                return
            }
            
            let id = info["id"] as? Int ?? -1
            let rightSwipe = info["rightSwipe"] as? Bool ?? false
            let width = getRect().width - 50
            
            if repository.id == id {
                offset = (rightSwipe ? width : -width) * 2
                endSwipeActions()
                if rightSwipe {
                    self.rightSwipe()
                } else {
                    leftSwipe()
                }
            }
        }
    }
    
    func getRotation(angle: Double) -> Double {
        let rotation = (offset / (getRect().width - 50)) * angle
        return rotation
    }
    
    func endSwipeActions() {
        withAnimation(.none){
            endSwipe = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if let _ = viewModel.displaying_repositories?.first {
                let _ = withAnimation {
                    viewModel.displaying_repositories?.removeFirst()
                }
            }
        }
    }
    
    func leftSwipe(){
        print("Left swiped")
    }
    
    func rightSwipe(){
        print("Right swiped")
    }
}

struct StackCardView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension View {
    func getRect() -> CGRect {
        return UIScreen.main.bounds
    }
}
