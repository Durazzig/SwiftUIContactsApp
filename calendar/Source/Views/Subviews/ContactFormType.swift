//
//  ContactFormType.swift
//  calendar
//
//  Created by Tadeo Durazo on 29/01/23.
//

import SwiftUI
import Contacts

enum ContactFormType: Identifiable, View {
    case new
    case update(CNContact)
    var id: String {
        switch self {
        case .new:
            return "new"
        case .update:
            return "update"
        }
    }

    var body: some View {
        switch self {
        case .new:
            return EventFormView(viewModel: EventFormViewModel())
        case .update(let event):
            return EventFormView(viewModel: EventFormViewModel(event))
        }
    }
}

