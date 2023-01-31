//
//  AddContactSubview.swift
//  calendar
//
//  Created by Tadeo Durazo on 29/01/23.
//

import SwiftUI

struct AddContactSubview: View {
    
    @StateObject var viewModel: AddContactViewModel
    
    var callbackFunction : () -> ()
    
    @State var isActive = false
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 10) {
                    CustomSection(header: "Personal Information") {
                
                        DefaultTextfield(title: "First Name", text: $viewModel.firstName)

                        DefaultTextfield(title: "Middle Name", text: $viewModel.middleName)

                        DefaultTextfield(title: "Last Name", text: $viewModel.lastName)
                        
                        DefaultTextfield(title: "Birthdate", text: $viewModel.birthdate)
                            .disabled(true)
                            .onTapGesture {
                                self.isActive = true
                            }
                    }
                    .padding()
                    
                    CustomSection(header: "Phone Information") {
                        
                        DefaultTextfield(title: "Phone number", text: $viewModel.phoneNumber)
                        
                    }
                    .padding()
                    
                    Button {
                        viewModel.isUpdate ? viewModel.updateContact() : viewModel.storeContact()
                        self.callbackFunction()
                        NavigationUtil.popToRootView()
                    } label: {
                        Text(viewModel.isUpdate ? "Update contact" : "Save contact")
                            .frame(maxWidth: .infinity)
                    }
                    .cornerRadius(15)
                    .buttonStyle(PinkButton())
                    .padding()

                }
            }
            .navigationDestination(isPresented: $isActive) {
                CalendarView(viewModel: viewModel)
            }
            .navigationTitle(viewModel.isUpdate ? "Update contact" : "Add new contact")
        }
    }
}
