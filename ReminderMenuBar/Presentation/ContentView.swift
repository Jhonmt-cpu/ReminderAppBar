//
//  ContentView.swift
//  ReminderMenuBar
//
//  Created by João Melo on 24/05/24.
//

import SwiftUI
import EventKit

struct ContentView: View {
    @ObservedObject var reminders: ReminderModelData
    
    var body: some View {
        if reminders.allReminders.isEmpty {
            EmptyStateReminders()
                .frame(width: 300)
        } else {
            VStack (alignment: .leading){
                Text("Here you can see all you next reminders")
                    .padding()
                List {
                    ForEach(reminders.allReminders, id: \.calendarItemIdentifier) { reminder in
                        ReminderToggle(reminder: reminder)
                    }
                    
                }
                .animation(.default, value: reminders.allReminders)
            }
            .frame(width: 300)
        }
       
    }
}

#Preview {
    let reminder = EKReminder(eventStore: EKEventStore())
    
    reminder.title = "Go to Gym"
    let remindersList: [EKReminder] = [
        reminder
    ]
    
    let reminders = ReminderModelData()
    reminders.allReminders = remindersList
    
    return ContentView(
        reminders: reminders
    )
}
