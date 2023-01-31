//
//  CustomViews.swift
//  calendar
//
//  Created by Tadeo Durazo on 29/01/23.
//

import Foundation
import SwiftUI

struct PinkButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(Color.pink)
            .foregroundColor(Color.white)
    }
}

struct CustomSection<Content: View>: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass

    let content: Content
    let header: String

    init(header: String ,@ViewBuilder _ content: () -> Content) {
        self.content = content()
        self.header = header
    }

    var body: some View {
        VStack {
            HStack {
                Text(header)
                Spacer()
            }
            content
            Spacer()
        }
    }
}

struct DefaultTextfield: View {
    
    let title: String
    @Binding var text: String
    
    var body: some View {
        TextField(title, text: $text)
            .modifier(defaultTextfield())
    }
}


struct defaultTextfield: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(Color.white)
            .cornerRadius(6)
            .foregroundColor(Color.black)
            .font(.custom("Open Sans", size: 14))
            .shadow(radius: 1)
    }
}

struct CustomLabel: View {
    
    let title: String
    let description: String?
    
    var body: some View {
        HStack {
            HStack {
                Text("\(title):")
                    .bold()
                Spacer()
            }
            HStack {
                Text(description ?? "Phone number not available")
                Spacer()
            }
        }
        .padding()
    }
}

struct DeleteDialogView: View {
    
    let title: String
    let subtitle: String
    let buttonText: String
    
    let action: () -> ()
    
    var body: some View {
        VStack {
            Text(title)
                .fontWeight(.bold)
            Divider()
            Text(subtitle)
                .padding(.bottom, 10)
            Button(action: {
                action()
            }) {
                Text(buttonText)
                    .autocapitalization(.allCharacters)
                    .frame(minWidth: 0, maxWidth: .infinity)
            }
            .cornerRadius(15)
            .buttonStyle(PinkButton())
        }.padding()
    }
}

struct CustomDialog<DialogContent: View>: View {
    @Binding var isShowing: Bool // set this to show/hide the dialog
    let dialogContent: DialogContent
    let isDismissable: Bool

    init(isShowing: Binding<Bool>, isDismissable: Bool,
    @ViewBuilder dialogContent: () -> DialogContent) {
        _isShowing = isShowing
        self.dialogContent = dialogContent()
        self.isDismissable = isDismissable
    }

    var body: some View {
        if isShowing {
            ZStack {
                Rectangle().foregroundColor(Color.black.opacity(0.6))
                    .ignoresSafeArea()
                ZStack {
                    dialogContent
                        .background(
                          RoundedRectangle(cornerRadius: 8)
                            .foregroundColor(.white))
                }
                .padding(40)
            }
            .onTapGesture {
                if self.isDismissable {
                    self.isShowing = false
                }
            }
        }
    }
}

struct NavigationUtil {
    static func popToRootView() {
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first?.rootViewController
        
        findNavigationController(viewController: window)?.popToRootViewController(animated: true)
    }
    static func findNavigationController(viewController: UIViewController?) -> UINavigationController? {
        guard let viewController = viewController else {
            return nil
        }
        
        if let navigationController = viewController as? UINavigationController {
            return navigationController
        }
        
        for childViewController in viewController.children {
            return findNavigationController(viewController: childViewController)
        }
        
        return nil
    }
}
