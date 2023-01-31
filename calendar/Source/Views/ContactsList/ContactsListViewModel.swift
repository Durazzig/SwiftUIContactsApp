//
//  ContactsListViewModel.swift
//  calendar
//
//  Created by Tadeo Durazo on 28/01/23.
//

import Foundation
import Contacts

class ContactsListViewModel: ObservableObject {
    
    @Published var contacts: [CNContact] = []
    
    var contactsBackup: [CNContact] = []
    
    init() {
        fetchContacts()
    }
    
    func fetchContacts() {
        
        let store = CNContactStore()
        
        let contactKeys = [CNContactGivenNameKey, CNContactMiddleNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey, CNContactBirthdayKey, CNContactImageDataAvailableKey, CNContactImageDataKey] as [CNKeyDescriptor]
        
        let fetchRequest = CNContactFetchRequest(keysToFetch: contactKeys)
        
        do {
            try store.enumerateContacts(with: fetchRequest, usingBlock: { contact, result in
                contacts.append(contact)
            })
            
            let sortedContacts = contacts.sorted {
                $0.givenName < $1.givenName
            }
            
            contacts.removeAll()
            
            for contact in sortedContacts {
                contacts.append(contact)
            }
            
            contactsBackup.append(contentsOf: contacts)
            
        } catch {
            print("The following error presented while fetching phone contacts: \(error)")
        }
        
    }
    
    func refreshContacts() {
        contacts.removeAll()
        self.fetchContacts()
    }
    
    func searchContacts(search: String) {
        let store = CNContactStore()
        
        let contactKeys = [CNContactGivenNameKey, CNContactMiddleNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey, CNContactBirthdayKey, CNContactImageDataAvailableKey, CNContactImageDataKey] as [CNKeyDescriptor]
        
        let predicate = CNContact.predicateForContacts(matchingName: search)
        
        do {
            contacts.removeAll()
            contacts = try store.unifiedContacts(matching: predicate, keysToFetch: contactKeys)
            
        } catch {
            print("The following error presented while fetching phone contacts: \(error)")
        }
    }
    
    func sortContacts(sortId: ContactsFilter) {
        
        var sortedContacts: [CNContact] = []
        switch sortId {
            case .all:
                contacts.removeAll()
                contacts.append(contentsOf: contactsBackup)
            case .ascendingBirthday:
                let notNilBirthdayContacts = contacts.filter {
                    $0.isBirthdayAvailable()
                }
                
                sortedContacts = notNilBirthdayContacts.sorted {
                    $0.getNextBirthdayDate().compare($1.getNextBirthdayDate()) == .orderedAscending
                }
                
                contacts.removeAll()
                contacts = sortedContacts
            case .descendingBirthday:
                let notNilBirthdayContacts = contacts.filter {
                    $0.isBirthdayAvailable()
                }
                
                sortedContacts = notNilBirthdayContacts.sorted {
                    $0.getNextBirthdayDate().compare($1.getNextBirthdayDate()) == .orderedDescending
                }
                
                contacts.removeAll()
                contacts = sortedContacts
        }
    }
    
}
