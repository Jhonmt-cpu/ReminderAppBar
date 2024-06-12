//
//  ReminderMenuBarApp.swift
//  ReminderMenuBar
//
//  Created by João Melo on 24/05/24.
//

import SwiftUI
import EventKit

@main
struct ReminderMenuBarApp: App {
    @StateObject private var reminders = ReminderModelData()
    
    var body: some Scene {
        MenuBarExtra {
            ContentView(reminders: reminders)
        } label: {
            if reminders.allReminders.isEmpty {
                Text("No reminders!")
                    .onAppear {
                        fetchReminders()
                    }
            } else {
                LabelMenuBar(reminder: $reminders.allReminders[0])
                    .frame(maxWidth: 300)
            }
        }
        .menuBarExtraStyle(.window)
    }
    
    private func fetchReminders() -> Void {
        reminders.showLists()
        reminders.showListItems(withName: "Reminders")
    }
}

