//
//  GroupFileView.swift
//  MyClubApp
//
//  Created by Pole Star on 05/09/2022.
//

import SwiftUI

struct GroupFileView: View {
    var body: some View {
        EmptyGroupFileView()
    }
}

struct GroupFileView_Previews: PreviewProvider {
    static var previews: some View {
        GroupFileView()
    }
}


struct EmptyGroupFileView: View {
    var body: some View {
        VStack( alignment: .center){
            Image(systemName: "paperclip")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 64, height: 52)
                .font(.title)
                .foregroundColor(.gray)
            
            Text("Pas d'articles")
                .font(.system(size: 20, weight: .black, design: .rounded))
                .foregroundColor(.gray)
            
            Text("La prise en charge permet de stocker des fichiers au format PDF, Excel, Word et des liens.")
                .font(.body)
                .foregroundColor(.gray)
        }
    }
}
