//
//  LabelMenuBar.swift
//  ReminderMenuBar
//
//  Created by João Melo on 26/05/24.
//

import SwiftUI
import EventKit

struct LabelMenuBar: View {
    @Binding var reminder: EKReminder
    
    var label: String {
        var reminderTitle = reminder.title ?? ""
        
        if reminderTitle.count > 23 {
            reminderTitle = "\(reminderTitle.prefix(20))..."
        }
        
        return reminderTitle
    }
    
    var body: some View {
        HStack {
            Image(systemName: "checklist")
                .resizable()
                .scaledToFit()
            Text(label)
                .foregroundColor(.white)
        }
        .fixedSize()
    }
}

#Preview {
    let reminder = EKReminder(eventStore: EKEventStore())
    
    reminder.title = "Go to Gym"
    
    return LabelMenuBar(
        reminder: .constant(reminder)
    )
}
