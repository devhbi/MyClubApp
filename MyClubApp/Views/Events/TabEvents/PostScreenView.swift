//
//  PostScreenView.swift
//  MyClubApp
//
//  Created by Honoré BIZAGWIRA on 04/09/2022.
//

import SwiftUI

struct PostScreenView: View {
    var body: some View {
        EmptyEventPostsView()
    }
}

struct PostScreenView_Previews: PreviewProvider {
    static var previews: some View {
        PostScreenView()
    }
}

struct EmptyEventPostsView: View {
    var body: some View {
        VStack( alignment: .center){
            Image(systemName: "pencil")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 64, height: 52)
                .font(.title)
                .foregroundColor(.gray)
            
            Text("Pas de posts")
                .font(.system(size: 20, weight: .black, design: .rounded))
                .foregroundColor(.gray)
            
            Text("Cliquer + pour créer un nouveau post")
                .font(.body)
                .foregroundColor(.gray)
        }
    }
}
