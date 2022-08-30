//
//  HomeWebView.swift
//  MyClub
//
//  Created by Honoré BIZAGWIRA on 30/08/2022.
//

import SwiftUI
import WebKit

struct HomeWebView: UIViewControllerRepresentable {
    let url: URL

    func makeUIViewController(context: Context) -> WebViewController {
        let webviewController = WebViewController()

        let request = URLRequest(url: self.url, cachePolicy: .returnCacheDataElseLoad)
        webviewController.webview.load(request)

        return webviewController
    }

    func updateUIViewController(_ webviewController: WebViewController, context: Context) {
        let request = URLRequest(url: self.url, cachePolicy: .returnCacheDataElseLoad)
        webviewController.webview.load(request)
    }
}
