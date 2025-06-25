//
//  ContentView.swift
//  Einkaufsliste
//
//  Created by Alexandre Samson on 25.06.25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    
    @State private var einkaufsliste = [""]
    @State private var newItemText = ""
    
    init() {
        if let storedItems = UserDefaults.standard.array(forKey: "einkaufslistestorage") as? [String] {
            _einkaufsliste = State(initialValue: storedItems)
        }
    }
    
    var body: some View {
        NavigationView {
            List(einkaufsliste, id: \.self) {
                artikel in Text(artikel)
            }
            .navigationTitle(Text("Einkaufsliste"))
        }
        HStack {
            TextField("Neuer Artikel", text: $newItemText).textFieldStyle(RoundedBorderTextFieldStyle())
            Button("Hinzufügen", action: {
                if !newItemText.isEmpty {
                    einkaufsliste.append(newItemText)
                    UserDefaults.standard.set(einkaufsliste, forKey: "einkaufslistestorage")
                    newItemText = ""
                }
            })
        }
        .padding(.horizontal)
    }

    private func addItem() {
        withAnimation {
            let newItem = Item(timestamp: Date())
            modelContext.insert(newItem)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
