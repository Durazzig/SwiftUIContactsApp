//
//  ContactFormSubviewViewModel.swift
//  calendar
//
//  Created by Tadeo Durazo on 29/01/23.
//

import Foundation
import Contacts

class ContactFormSubviewViewModel: ObservableObject {
    @Published var date = Date()
    @Published var note = ""
    @Published var eventType: CNContact.EventType = .unspecified

    var id: String?
    var updating: Bool { id != nil }

    init() {}

    init(_ contact: CNContact) {
        date = event.date
        note = event.note
        eventType = event.eventType
        id = event.id
    }

    var incomplete: Bool {
        note.isEmpty
    }
}
