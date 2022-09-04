//
//  HistoricView.swift
//  MyClubApp
//
//  Created by Honoré BIZAGWIRA on 01/09/2022.
//

import SwiftUI

struct HistoricView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("HISTORIQUE")
                .font(.title)
        }
        .frame(
          minWidth: 0,
          maxWidth: .infinity,
          minHeight: 0,
          maxHeight: .infinity
        )
        .background(Color.red)
    }
}

struct HistoricView_Previews: PreviewProvider {
    static var previews: some View {
        HistoricView()
    }
}
