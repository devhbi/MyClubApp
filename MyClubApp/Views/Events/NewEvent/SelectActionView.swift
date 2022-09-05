//
//  SelectActionView.swift
//  MyClubApp
//
//  Created by Pole Star on 05/09/2022.
//

import SwiftUI

struct SelectActionView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.presentationMode) private var presentationMode
    
    @State var selectedAction: SelectActionTypeModel = .defaultAction
    @State var selectedPeriod: SelectActionFrequencyModel = .defaultPeriod
    
    var actions: [SelectActionTypeModel] = SelectActionTypeModel.actions
    var periods: [SelectActionFrequencyModel] = SelectActionFrequencyModel.periods
    
    @ObservedObject var eventVM: EventVM
    @StateObject var presentedView: CreateEventRouter
    
    var body: some View {
        GeometryReader { _ in
            NavigationView {
                VStack {
                    Text("Créer un événement").font(.headline)
                    List {
                        actionList
                        periodList
                        continueButton
                    }
                    .padding(.vertical, 32)
                }
                .navigationTitle("Contextes")
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Cancel", role: .cancel) {
                            self.presentedView.currentView = .action
                            handleDismissal()
                        }
                    }
                }
            }
        }
    }
}

private extension SelectActionView {
    func handleDismissal() {
        if #available(iOS 15.0, *) {
            dismiss()
        }
        else {
            presentationMode.wrappedValue.dismiss()
        }
        
    }
}
extension SelectActionView{
    
    var continueButton: some View {
        Section {
            Button("Continuer") {
                self.eventVM.event.typeAction = self.selectedAction.action
                self.eventVM.event.frequency = self.selectedPeriod.action
                self.presentedView.currentView = .group
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .font(.system(size: 24, weight: .black, design: .rounded))
            .padding(.vertical, 4)
            .listRowBackground(Color(UIColor.systemBlue))
            .buttonStyle(.borderless)
            .foregroundColor(Color(UIColor.systemBackground))
        }
    }
}

extension SelectActionView{
    
    var actionList: some View {
        Section {
            ForEach(self.actions, id: \.self) { action in
                HStack {
                    Image(systemName: action.imageName)
                        .font(.title)
                        .foregroundColor(.blue)
                    Text(action.name)
                    
                    Spacer()
                    Image(systemName: self.selectedAction == action ? "checkmark.circle" : "circle")
                        .font(.title)
                        .foregroundColor( self.selectedAction == action ? .green : .blue)
                }
                .onTapGesture {
                    self.selectedAction = action
                }
            }
        }
        header:{
            Text("Que voulez-vous créer?")
        }
    }
}

extension SelectActionView{
    
    var periodList: some View {
        Section {
            ForEach(self.periods, id: \.self) { period in
                HStack {
                    Image(systemName: period.imageName)
                        .font(.title)
                        .foregroundColor(.blue)
                    Text(period.name)
                    
                    Spacer()
                    Image(systemName: self.selectedPeriod == period ? "checkmark.circle" : "circle")
                        .font(.title)
                        .foregroundColor( self.selectedPeriod == period ? .green : .blue)
                }
                .onTapGesture {
                    self.selectedPeriod = period
                }
            }
        }
        header:{
            Text("Pour quelle durée?")
        }
    }
}

struct SelectActionView_Previews: PreviewProvider {
    static var previews: some View {
        SelectActionView(eventVM: EventVM(), presentedView: CreateEventRouter())
    }
}
