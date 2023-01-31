//
//  AddContactViewModel.swift
//  calendar
//
//  Created by Tadeo Durazo on 29/01/23.
//

import Foundation
import Contacts
import SwiftUI

class AddContactViewModel: ObservableObject {
    
    @StateObject var contactsListViewModel = ContactsListViewModel()
    
    @Published var firstName = ""
    @Published var middleName = ""
    @Published var lastName = ""
    @Published var phoneNumber = ""
    @Published var birthdate = ""
    @Published var isUpdate = false
    @Published var contact = CNMutableContact()
    
    init() {}

    init(contact: CNContact, update: Bool) {
        self.firstName = contact.givenName
        self.middleName = contact.middleName
        self.lastName = contact.familyName
        if contact.phoneNumbers.first != nil {
            self.phoneNumber = contact.phoneNumber()
        }else {
            self.phoneNumber = ""
        }
        self.birthdate = contact.birthday != nil ? contact.birthday().formatDate.formatted(date: .long, time: .omitted) : ""
        self.contact = contact.mutableCopy() as? CNMutableContact ?? CNMutableContact()
        self.isUpdate = update
    }
    
    func storeContact() {
        let contact = CNMutableContact()

        contact.givenName = firstName
        contact.middleName = middleName
        contact.familyName = lastName
        if birthdate != "" {
            contact.birthday = Calendar.current.dateComponents([.year, .month, .day], from: birthdate.formatDate)
        }
        if phoneNumber != "" {
            contact.phoneNumbers = [CNLabeledValue(label: CNLabelPhoneNumberiPhone, value: CNPhoneNumber(stringValue: phoneNumber))]
        }

        let store = CNContactStore()
        let saveRequest = CNSaveRequest()
        saveRequest.add(contact, toContainerWithIdentifier: nil)
        do {
            try store.execute(saveRequest)
        } catch {
            print("Error occur: \(error)")
        }
    }
    
    func updateContact() {
        contact.givenName = firstName
        contact.middleName = middleName
        contact.familyName = lastName
        if birthdate != "" {
            contact.birthday = Calendar.current.dateComponents([.year, .month, .day], from: birthdate.formatDate)
        }
        if phoneNumber != "" {
            contact.phoneNumbers = [CNLabeledValue(label: CNLabelPhoneNumberiPhone, value: CNPhoneNumber(stringValue: phoneNumber))]
        }
        
        let store = CNContactStore()
        let saveRequest = CNSaveRequest()
        saveRequest.update(contact)
        do {
            try store.execute(saveRequest)
        } catch {
            print("Error occur: \(error)")
        }
    }
    
    func deleteContact() {
        let store = CNContactStore()
        let saveRequest = CNSaveRequest()
        saveRequest.delete(contact)
        do {
            try store.execute(saveRequest)
        } catch {
            print("Error occur: \(error)")
        }
    }
    
}
