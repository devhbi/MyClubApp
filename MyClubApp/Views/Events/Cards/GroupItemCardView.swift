//
//  GroupItemCardView.swift
//  MyClubApp
//
//  Created by Honoré BIZAGWIRA on 04/09/2022.
//

import SwiftUI

struct GroupItemCardView: View {
    @State var vm: GroupVM
    var body: some View {
        GeometryReader { reader in
            VStack(spacing: 6) {
                Image(systemName: "person.3.fill")
                    .foregroundColor(.white)
                    .frame(width: 64, height: 64, alignment: .center)
                    .background(Color(.systemBlue))
                    .clipShape(Circle())
                
                Text(vm.group.name)
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                Text(vm.administrator)
                    .font(.callout)
                    .foregroundColor(.gray)
            }
            .frame(width: reader.size.width, height: reader.size.height)
        }
        .frame(height: 148)
    }
}

struct GroupItemCardView_Previews: PreviewProvider {
    static var previews: some View {
        GroupItemCardView(vm: GroupVM())
    }
}
