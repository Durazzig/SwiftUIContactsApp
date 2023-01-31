//
//  ContactsListView.swift
//  calendar
//
//  Created by Tadeo Durazo on 28/01/23.
//

import SwiftUI

enum ContactsFilter: String {
    
    static var allFilter: [ContactsFilter] {
        return [.all, .ascendingBirthday, .descendingBirthday]
    }
    
    case all = "All"
    case ascendingBirthday = "Ascending birthday"
    case descendingBirthday = "Descending birthday"
}

struct ContactsListView: View {
    
    @EnvironmentObject var viewModel: ContactsListViewModel
    
    @State var isActive = false
    
    @State private var search = ""
    
    @State var selectedFilter = ContactsFilter.all
    
    var body: some View {
        NavigationStack {
            
            VStack {                
                List {
                    ForEach(viewModel.contacts, id: \.self) {
                        contact in
                        ContactRowSubview(contact: contact)
                    }
                }
                .refreshable {
                    viewModel.refreshContacts()
                }
                .searchable(text: $search)
                .onChange(of: search, perform: { search in
                    if !search.isEmpty {
                        viewModel.searchContacts(search: search)
                    } else {
                        viewModel.refreshContacts()
                    }
                })
                .navigationTitle("Contacts")
                .toolbar {
                    Text("Filter:")
                    
                    Picker("", selection: $selectedFilter.animation()) {
                        ForEach(ContactsFilter.allFilter, id: \.self) {
                            filter in
                            Text(filter.rawValue)
                        }
                    }
                    .onChange(of: selectedFilter) { value in
                        sortContacts(filter: value)
                    }
                    
                    NavigationLink {
                        AddContactSubview(viewModel: AddContactViewModel(), callbackFunction: refreshContacts)
                    } label: {
                        Label("", systemImage: "plus.app")
                    }
                }
            }
        }
    }
    
    func sortContacts(filter: ContactsFilter) {
        viewModel.sortContacts(sortId: filter)
    }
    
    func refreshContacts() {
        self.viewModel.refreshContacts()
    }
}

