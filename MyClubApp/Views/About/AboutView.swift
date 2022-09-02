//
//  AboutView.swift
//  MyClubApp
//
//  Created by Honoré BIZAGWIRA on 31/08/2022.
//

import SwiftUI
import WebKit

import SwiftUI
import WebKit

enum WebViewError: Error {
    case contentConversion(String)
    case emptyFileName
    case invalidFilePath
    
    var message: String {
        switch self {
        case let .contentConversion(message):
            return "There was an error converting the file path to an HTML string. Error \(message)"
        case .emptyFileName:
            return "The file name was empty."
        case .invalidFilePath:
            return "The file path is invalid."
        }
    }
}

struct WebView: UIViewRepresentable {
    let htmlFileName: String
    private let webView = WKWebView()
    let onError: (WebViewError) -> Void
    
    func makeUIView(context: Context) -> WKWebView {
        webView.configuration.preferences.setValue(true, forKey: "allowFileAccessFromFileURLs")
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        webView.load(htmlFileName, onError: onError)
    }
}

extension WKWebView {
    func load(_ htmlFileName: String, onError: (WebViewError) -> Void) {
        guard !htmlFileName.isEmpty else {
            return onError(.emptyFileName)
        }
        
        guard let filePath = Bundle.main.path(forResource: htmlFileName, ofType: "html") else {
            return onError(.invalidFilePath)
        }
        
        do {
            let htmlString = try String(contentsOfFile: filePath, encoding: .utf8)
            loadHTMLString(htmlString, baseURL: URL(fileURLWithPath: filePath))
        }
        catch let error{
            return onError(.contentConversion(error.localizedDescription))
        }
    }
}

struct AboutView: View {
    var body: some View {
        WebView(htmlFileName: "about", onError: {error in
            print(error.message)
        })
    }
}


