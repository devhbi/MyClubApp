//
//  ToastView.swift
//  MyClubApp
//
//  Created by Honoré BIZAGWIRA on 03/09/2022.
//

import SwiftUI

struct Toast {
    var title: String
    var image: String
}


struct ToastView: View {
    let toast: Toast
    @Binding var show: Bool
     
var body: some View {
        VStack {
            Spacer()
            HStack {
                Image(systemName: toast.image)
                    .font(.title)
                Text(toast.title)
            }
            .font(.headline)
            .foregroundColor(.primary)
            .padding(.vertical, 20)
            .background(.orange.opacity(0.4), in: Capsule())
        }
        .frame(width: UIScreen.main.bounds.width)
        .transition(AnyTransition.move(edge: .bottom).combined(with: .opacity))
        .onTapGesture {
            withAnimation {
                self.show = false
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3){
                self.show = false
            }
        }
    }
}


struct Overlay<T: View>: ViewModifier {
    @Binding var show: Bool
    let overlayView: T
    
    func body(content: Content) -> some View {
        ZStack {
            content
            if show {
                overlayView
            }
        }
    }
}

extension View {
    func overlay<T: View>(overlayView: T, show: Binding<Bool>) -> some View {
        self.modifier(Overlay(show: show, overlayView: overlayView))
    }
}

//struct ToastView_Previews: PreviewProvider {
//    @State var showToast = false
//    static var previews: some View {
//        ToastView (toast: Toast(title: "Mis à jour avec succès", image: "checkmark.circle.fill"), show: self.$showToast)
//    }
//}
