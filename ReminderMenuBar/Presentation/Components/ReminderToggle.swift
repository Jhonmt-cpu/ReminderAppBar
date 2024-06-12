//
//  ReminderToggle.swift
//  ReminderMenuBar
//
//  Created by João Melo on 27/05/24.
//

import SwiftUI
import EventKit

let reminders = ReminderModelData()

struct ReminderToggle: View {
    @State private var isCompleted = false
    var reminder: EKReminder
    
    var body: some View {
        HStack {
            Text(reminder.title)
            Spacer()
            Toggle(isOn: $isCompleted, label: {
               Text("Completed")
            })
            .toggleStyle(.checkbox)
            .onChange(of: isCompleted) { oldValue, newValue in
                reminders.complete(reminder: reminder)
            }
        }
    }
}

#Preview {
    let reminder = EKReminder(eventStore: EKEventStore())
    
    reminder.title = "Go to Gym"
    
    return ReminderToggle(
        reminder: reminder
    )
}
