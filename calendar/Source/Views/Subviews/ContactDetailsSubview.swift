//
//  ContactDetailsSubview.swift
//  calendar
//
//  Created by Tadeo Durazo on 29/01/23.
//

import SwiftUI
import Contacts
import CoreLocation

struct ContactDetailsSubview: View {
    
    @EnvironmentObject var contactsListViewModel: ContactsListViewModel
    
    @StateObject var viewModel: AddContactViewModel
    
    @StateObject var locationManager = LocationManager()
    
    let contact: CNContact
    
    @State var selection: Int?
    
    @State private var showDeleteDialog = false
    
    var body: some View {
        
        ZStack {
            ScrollView {
                VStack {
                    HStack {
                        Spacer()
                        Image(uiImage: contact.contactImage())
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 200, height: 200, alignment: .center)
                            .clipShape(Circle())
                        Spacer()
                    }
                    
                    HStack {
                        Spacer()
                        NavigationLink(destination: AddContactSubview(viewModel: AddContactViewModel(contact: contact, update: true), callbackFunction: refreshContacts), tag: 1, selection: $selection) {
                            Button {
                                self.selection = 1
                            } label: {
                                HStack {
                                    Spacer()
                                    Image(systemName: "pencil")
                                    Text("Edit")
                                        .frame(maxWidth: .infinity)
                                    Spacer()
                                }
                            }
                            .cornerRadius(15)
                            .buttonStyle(PinkButton())
                            .padding()
                        }
                        Spacer()
                        Button {
                            self.showDeleteDialog = true
                        } label: {
                            HStack {
                                Spacer()
                                Image(systemName: "trash")
                                Text("Delete")
                                    .frame(maxWidth: .infinity)
                                Spacer()
                            }
                        }
                        .cornerRadius(15)
                        .buttonStyle(PinkButton())
                        .padding()
                        Spacer()
                    }
                    
                    CustomLabel(title: "Name", description: contact.fullName())
                    
                    CustomLabel(title: "Phone number", description: contact.phoneNumber())
                    
                    CustomLabel(title: "Birthday", description: contact.birthday())
                    
                    if viewModel.contact.isBirthdayAvailable() && locationManager.isLocationReady {
                        if viewModel.contact.birthday().formatDate.formatted(date: .long, time: .omitted) == Date().formatted(date: .long, time: .omitted) {
                            WeatherSubview(viewModel: WeatherViewModel(lat: userLatitude, long: userLongitude))
                        }
                    }

                }
            }
            .navigationTitle("Contact details")
            
            CustomDialog(isShowing: $showDeleteDialog, isDismissable: true) {
                DeleteDialogView(title: "Delete contact", subtitle: "Are you sure you want to delete this contact?", buttonText: "Delete") {
                    viewModel.deleteContact()
                    refreshContacts()
                    showDeleteDialog = false
                    NavigationUtil.popToRootView()
                }
            }
        }
        .onAppear {
            locationManager.checkIfLocationServicesIsEnabled()
        }
        
    }
    
    var userLatitude: String {
        return "\(locationManager.locationManager?.location?.coordinate.latitude ?? 0)"
    }

    var userLongitude: String {
        return "\(locationManager.locationManager?.location?.coordinate.longitude ?? 0)"
    }
    
    func refreshContacts() {
        self.contactsListViewModel.refreshContacts()
    }
}
