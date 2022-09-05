//
//  EventScreenView.swift
//  MyClubApp
//
//  Created by Honoré BIZAGWIRA on 04/09/2022.
//

import SwiftUI

import SwiftUI

struct EventScreenView: View {
    @StateObject var presentedEventRouterView: CreateEventRouter = CreateEventRouter()
    @ObservedObject var eventListVM = EventListVM()
    @State var showAddEventSheetView: Bool = false
    @State private var numberOfRows = 1
    @EnvironmentObject var accountVM: AccountViewModel
    let spacing: CGFloat = 10
    @State private var selectedTabIndex = 0
    
    var body: some View {
        let columns = Array(repeating: GridItem(.flexible(),  spacing: spacing), count: self.numberOfRows)

        ZStack(alignment: .bottom) {
            ScrollView {
                LazyVGrid(columns: columns, spacing: spacing) {
                    ForEach (self.eventListVM.eventVMs , id: \.self) {eventVM in
                        EventCardButton(evtListVM: eventListVM, evtVM: eventVM)
                    }
                }
                .padding(.all, 10)
            }

            if (!self.accountVM.isMember) {
                AddEventButton
            }
        }
        .navigationBarHidden(true)
        .onAppear (perform: eventListVM.load)
        .fullScreenCover(isPresented: $showAddEventSheetView, onDismiss: {
            withAnimation {
                eventListVM.load()
            }
        }, content: {
            CreateNewEventView(presentedView: presentedEventRouterView, eventListVM: eventListVM)
        })
    }
}

extension EventScreenView {
    var AddEventButton: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button(action: {
                    withAnimation {
                        self.showAddEventSheetView.toggle()
                    }
                }, label: {
                    Text("+")
                        .font(.system(.largeTitle))
                        .frame(width: 64, height: 56)
                        .foregroundColor(Color.white)
                        .padding(.bottom, 8)
                })
                .background(Color.blue)
                .cornerRadius(38.5)
                .padding()
                .shadow(color: Color.black.opacity(0.3),
                        radius: 3,
                        x: 3,
                        y: 3)
                .opacity(self.accountVM.isMember ? 0 : 1)
                .disabled(self.accountVM.isMember)
            }
        }
    }
}

struct EventCardButton:View {
    @State private var isPresented = false
    @ObservedObject var evtListVM: EventListVM
    let evtVM: EventVM
    var body: some View {
        Button(action: {
            isPresented.toggle()
        }, label: {
            EventItemCardView(vm: evtVM)
        })
        .fullScreenCover(isPresented: $isPresented, onDismiss: {
            withAnimation {
                evtListVM.load()
            }
        }, content: {
            EventDetailView(vm: evtVM)
        })
        .buttonStyle(ItemButtonStyle(cornerRadius: 16))
    }
}



struct EventScreenView_Previews: PreviewProvider {
    static var previews: some View {
        EventScreenView()
    }
}
