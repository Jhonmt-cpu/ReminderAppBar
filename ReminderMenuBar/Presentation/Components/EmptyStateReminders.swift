//
//  EmptyStateReminders.swift
//  ReminderMenuBar
//
//  Created by João Melo on 11/06/24.
//

import SwiftUI
import AppKit

struct EmptyStateReminders: View {
    var body: some View {
        VStack {
            Image(systemName: "bell.slash")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundColor(.gray)
                .padding(.bottom, 20)
            
            Text("No Reminders")
                .font(.title)
                .foregroundColor(.primary)
                .padding(.bottom, 5)
            
            Text("You don't have any reminders at the moment. Add a new reminder to get started!")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
}

#Preview {
    EmptyStateReminders()
}
