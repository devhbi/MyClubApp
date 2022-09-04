//
//  EventDetailView.swift
//  MyClubApp
//
//  Created by Pole Star on 04/09/2022.
//

import SwiftUI

struct EventDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.presentationMode) private var presentationMode
    @State private var isPresented = false
    @State private var isShowingEditConfirmation = false
    @State var vm: EventVM
    
    var body: some View {
        NavigationView {
            VStack (spacing: 0) {
                HStack {
                    Text(self.vm.event.name)
                        .font(.system(size: 32, weight: .black, design: .rounded))
                        .foregroundColor(Color(UIColor.label))
                    Spacer()
                }
                .padding(.horizontal)
                
                VStack(alignment: .leading) {
                    List {
                        Section {
                            EditButtonBar
                                .listRowSeparator(.hidden)
                        }
                        
                        Section {
                            ListRowView(name: "Organisateur: ", value: vm.admin)
                            
                            EventDetailTextItemView(imageName: "stopwatch", text: self.vm.event.type.rawValue.localizedCapitalized, color: .cyan)
                                .listRowSeparator(.hidden)
                            EventDetailDateItemView(imageName: "calendar.circle", model: vm)
                                .listRowSeparator(.hidden)
                            EventDetailTextItemView(imageName: "sportscourt", text: self.vm.event.opposingTeam, color: .cyan)
                                .listRowSeparator(.hidden)
                            EventDetailTextItemView(imageName: "person.2.circle", text: self.vm.event.group, color: .cyan)
                                .listRowSeparator(.hidden)
                        }
                        
                        Section {
                            EventDetailTextItemView(imageName: "checkmark.circle", text: "\(self.vm.event.accepted) participant(s)", color: .green)
                                .listRowSeparator(.hidden)
                            EventDetailTextItemView(imageName: "equal.circle",  text:"\(self.vm.event.inwaiting) sans réponse(s)",   color: .orange)
                                .listRowSeparator(.hidden)
                            EventDetailTextItemView(imageName: "nosign", text:"\(self.vm.event.refused) refusé(s)",  color: .red)
                                .listRowSeparator(.hidden)
                        }
                        header:{
                            Text("Réponses")
                                .font(.system(size: 16, weight: .heavy, design: .rounded))
                        }
                        
                        Section {
                            if vm.isInwaiting {
                                TitleRowView(title: "Répondre de la part de", subtitle: vm.admin)
                                    .listRowSeparator(.hidden)
                            }
                        }
                        
                        Section {
                            ValidButtonBar
                                .listRowSeparator(.hidden)
                        }
                        .buttonStyle(BorderlessButtonStyle())
                    }
                    .listStyle(InsetGroupedListStyle())
                }
                

            }
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading){
                    Button {
                        handleDismissal()
                    }
                    label:{
                        Image(systemName: "xmark")
                            .font(.title)
                            .imageScale(.small)
                            .frame(width: 32, height: 32)
                            .foregroundColor(.accentColor)
                    }
                }
                ToolbarItemGroup(placement: .navigationBarTrailing){
                    Button {
                        
                    }
                    label:{
                        Image(systemName: "ellipsis")
                            .font(.title)
                            .imageScale(.small)
                            .frame(width: 32, height: 32)
                            .foregroundColor(.accentColor)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct ListRowView: View {
    @Environment(\.editMode) var editMode
    
    let name: String
    let value: String
    
    var body: some View {
        HStack (spacing: 16){
            Text(name)
                .font(.system(size: 16, weight: .medium, design: .default))
            Text(value)
            Spacer()
        }
    }
}

struct TitleRowView: View {
    
    let title: String
    var subtitle: String = ""
    
    var body: some View {
        VStack (alignment: .leading, spacing: 2){
            Text(title)
                .font(.system(size: 16, weight: .heavy, design: .rounded))
            Text(subtitle)
        }
    }
}

struct EventDetailDateItemView: View {
    var imageName: String
    @State var model: EventVM
    var body: some View {
        HStack {
            Image(systemName: imageName)
                .resizable()
                .frame(width: 32, height: 32)
                .padding(.trailing, 10)
                .foregroundColor(.cyan)
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Début: ")
                        .font(.system(size: 16, weight: .medium, design: .default))
                        .lineLimit(1)
    
                    Text("\(model.event.startDate.toString(format: "dd/MM/yyyy")) à \(model.event.startTime)")
                        .font(.callout)
                        .lineLimit(1)
                }
                
                HStack {
                    Text("Fin: à" )
                        .font(.system(size: 16, weight: .medium, design: .default))
                        .lineLimit(1)
                    
//                    Text(model.endTime.toString(format: "HH:mm"))
                    Text(model.event.endTime)
                        .font(.callout)
                        .lineLimit(1)
                }
            }
            Spacer()
        }
    }
}

struct EventDetailTextItemView: View {
    var imageName: String
    var text: String
    var color: Color = .accentColor
    var body: some View {
        
        HStack {
            Image(systemName: self.imageName)
                .resizable()
                .frame(width: 32, height: 32)
                .padding(.trailing, 10)
                .foregroundColor( self.color)

            Text(self.text)
                .fixedSize(horizontal: false, vertical: true)
                .foregroundColor(Color.black.opacity(0.87))
        }
        .frame(height: 35)
        
    }
}

struct EventDetailButtonStyle: ButtonStyle {
    let bgColor: Color
    let fgColor: Color
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .font(.headline.bold())
            .foregroundColor(fgColor)
            .frame(height: 48)
            .frame(maxWidth: .infinity)
            .background(bgColor)
            .cornerRadius(8)
    }
}

extension EventDetailView {
    var ValidButtonBar: some View {
        HStack {
            
            Button(action: {
                withAnimation {
                    vm.accept()
                }
                print("Accepter")
            }, label: {
                Text("Accepter")
                    .font(.system(size: 18, weight: .black, design: .rounded))
            })
            .buttonStyle(EventDetailButtonStyle(bgColor: Color(UIColor.systemBlue), fgColor: .white))
            
            Button(action: {
                withAnimation {
                    vm.refuse()
                }
                print("Réfuser")
            }, label: {
                Text("Réfuser")
                    .font(.system(size: 18, weight: .black, design: .rounded))
            })
            .buttonStyle(EventDetailButtonStyle(bgColor: Color(UIColor.systemGray).opacity(0.4), fgColor: Color(UIColor.systemRed)))
        }
    }
}

extension EventDetailView {
    var EditButtonBar: some View {
        HStack {
            
            Button(action: {
                print("Modifier")
            }, label: {
                Text("Modifier")
                    .font(.system(size: 18, weight: .black, design: .rounded))
            })
            .buttonStyle(EventDetailButtonStyle(bgColor: Color(UIColor.black).opacity(0.4), fgColor: Color(UIColor.white)))
            
            Button(action: {
                withAnimation {
                    self.isShowingEditConfirmation.toggle()
                }
                
            }, label: {
                Text("Supprimer")
                    .font(.system(size: 18, weight: .black, design: .rounded))
            })
            .buttonStyle(EventDetailButtonStyle(bgColor: Color(UIColor.systemRed), fgColor: Color(UIColor.white)))
            .confirmationDialog("Voulez-vous vraiment supprimer l'événement \(self.vm.event.name)?", isPresented: self.$isShowingEditConfirmation, titleVisibility: .visible){
                Button("Supprimer",  role: .destructive) {
                    withAnimation {
                        self.vm.delete()
                        handleDismissal()
                    }
                }
                Button("Non", role: .cancel) {}
            }
        }
    }
}

private extension EventDetailView {
    var validButtons: some View {
        Section {
            HStack {
                Button(action: {
                    isPresented.toggle()
                }, label: {
                    Text("Accepter")
                        .font(.system(size: 18, weight: .black, design: .rounded))
                        .padding(.vertical, 4)
                })
                .buttonStyle(ValidButtonStyle(color: Color.blue))
                Spacer()
                Button(action: {
                    isPresented.toggle()
                }, label: {
                    Text("Réfuser")
                        .font(.system(size: 18, weight: .black, design: .rounded))
                        .padding(.vertical, 4)
                })
                .buttonStyle(ValidButtonStyle(color: Color(UIColor.systemRed)))
            }
            .frame(height: 50)
            .padding(.horizontal, 20)
        }
    }
}

private extension EventDetailView {
    var general: some View {
        Section {
            ListRowView(name: "Nom", value: self.vm.event.name)
            ListRowView(name: "Type", value: self.vm.event.type.rawValue.localizedCapitalized)
            ListRowView(name: "Organisateur", value: vm.organizer)
            ListRowView(name: "Début", value: self.vm.event.startDate.toString(format: "dd/MM/yyyy"))
            ListRowView(name: "Fin", value: self.vm.event.endDate.toString(format: "dd/MM/yyyy"))
        }
        header:{
            Text("Événement")
        }
    }
    
    var description: some View {
        Section {
            Text(self.vm.event.description)
                .font(Font.system(size: 16).italic())
        }
        header:{
            Text("Description")
        }
    }
    
    var addButton: some View {
        Section {
            Button(action: {
                isPresented.toggle()
            }, label: {
                Text("Ajouter un nouveau membre")
                    .frame(maxWidth: .infinity, alignment: .center)
                    .font(.system(size: 18, weight: .black, design: .rounded))
                    .padding(.vertical, 4)
                    .listRowBackground(Color(UIColor.systemBlue))
                    .buttonStyle(.borderless)
            })
            .fullScreenCover(isPresented: $isPresented) {
                AddMemberEventView(eventVM: self.$vm)
            }
        }
    }
}


struct ValidButtonStyle: ButtonStyle {
    let color: Color
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .font(.headline)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .contentShape(Rectangle())
            .listRowBackground(configuration.isPressed ? color.opacity(0.5) : Color.blue)
    }
}

private extension EventDetailView {
    func handleDismissal() {
        if #available(iOS 15.0, *) {
            dismiss()
        }
        else {
            presentationMode.wrappedValue.dismiss()
        }
        
    }
}
