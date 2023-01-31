//
//  CalendarView.swift
//  calendar
//
//  Created by Tadeo Durazo on 29/01/23.
//

import SwiftUI

struct CalendarView: View {
    
    @StateObject var viewModel: AddContactViewModel
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView {
            CalendarComponent(
                interval: DateInterval(start: .distantPast, end: .distantFuture),
                viewModel: viewModel,
                callbackFunction: popView
            )
        }
        .navigationTitle("Calendar")
    }
    
    func popView() {
        dismiss()
    }
}

struct CalendarComponent: UIViewRepresentable {
    
    let interval: DateInterval
    
    @ObservedObject var viewModel: AddContactViewModel
    
    var callbackFunction : () -> ()
    
    func makeUIView(context: Context) -> UICalendarView {
        let view = UICalendarView()
        let calendar = Calendar.current
        view.delegate = context.coordinator
        view.calendar = Calendar(identifier: .gregorian)
        view.availableDateRange = interval
        view.setVisibleDateComponents(viewModel.contact.birthday ?? calendar.dateComponents([.year, .month, .day], from: Date()), animated: true)
        let dateSelection = UICalendarSelectionSingleDate(delegate: context.coordinator)
        view.selectionBehavior = dateSelection
        return view
    }
    
    func updateUIView(_ uiView: UICalendarView, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self, viewModel: _viewModel, callbackFunction: callbackFunction)
    }
    
    class Coordinator: NSObject, UICalendarViewDelegate, UICalendarSelectionSingleDateDelegate {
        
        var parent: CalendarComponent
        
        @ObservedObject var viewModel: AddContactViewModel
        
        var callbackFunction : () -> ()
        
        init(parent: CalendarComponent, viewModel: ObservedObject<AddContactViewModel>, callbackFunction: @escaping () -> ()) {
            self.parent = parent
            self._viewModel = viewModel
            self.callbackFunction = callbackFunction
        }
        
        @MainActor
        func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {

            if !viewModel.contact.isBirthdayAvailable() {
                return nil
            }
            
            if viewModel.contact.birthday().formatDate.formatted(date: .abbreviated, time: .omitted) == dateComponents.date!.formatted(date: .abbreviated, time: .omitted) {
                return .customView {
                    let icon = UILabel()
                    icon.text = "🎉"
                    return icon
                }
            }
            
            return .none
        }
        
        func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {

            guard let dateComponents else { return }
            
            viewModel.birthdate = Calendar.current.date(from: dateComponents)?.formatted(date: .long, time: .omitted) ?? Date().formatted(date: .long, time: .omitted)
            print(viewModel.birthdate)
            callbackFunction()
        }
        
        func dateSelection(_ selection: UICalendarSelectionSingleDate, canSelectDate dateComponents: DateComponents?) -> Bool {
            return true
        }
        
    }
    
}

