//
//  ContactFormSubview.swift
//  calendar
//
//  Created by Tadeo Durazo on 29/01/23.
//

import SwiftUI

struct ContactFormSubview: View {
    @EnvironmentObject var contactsViewModel: ContactsListViewModel
    @StateObject var viewModel: ContactFormSubviewViewModel
    @Environment(\.dismiss) var dismiss
    @FocusState private var focus: Bool?
    
    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    
                }
            }
            .navigationTitle(viewModel.updating ? "Update" : "New Event")
            .onAppear {
                focus = true
            }
        }
    }
}

//struct ContactFormSubview_Previews: PreviewProvider {
//    static var previews: some View {
//        ContactFormSubview()
//    }
//}
