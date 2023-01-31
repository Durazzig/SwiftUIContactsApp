//
//  ContactRowSubview.swift
//  calendar
//
//  Created by Tadeo Durazo on 28/01/23.
//

import SwiftUI
import Contacts

struct ContactRowSubview: View {
    
    let contact: CNContact
    
    @State var isActive = false
    
    var body: some View {
        HStack {
            Image(uiImage: contact.contactImage())
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 50, height: 50, alignment: .center)
                .clipShape(Circle())
            Spacer()
            VStack {
                HStack {
                    Text(contact.givenName)
                    Spacer()
                }
                HStack {
                    Text(contact.phoneNumber())
                    Spacer()
                }
                HStack {
                    Text("Birthday: \(contact.getNextBirthdayString())")
                    Spacer()
                }
            }
            .foregroundColor(Color.black)
        }
        .padding()
        .cornerRadius(15)
        .onTapGesture {
            self.isActive = true
        }
        .navigationDestination(isPresented: $isActive) {
            ContactDetailsSubview(viewModel: AddContactViewModel(contact: contact, update: false) ,contact: self.contact)
        }
    }
}
