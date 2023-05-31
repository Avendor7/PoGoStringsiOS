//
//  ContentView.swift
//  PoGoStrings
//
//  Created by Stephen Wiggins on 2023-05-30.
//

import SwiftUI
import CoreData
import UIKit

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.item, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    
    @State var newString: String
    @State var actionSheetVisible = false
    @State var alertVisible = false
    var body: some View {
        VStack{
            Text("PoGo Strings")
            List {
                ForEach(items) { item in
                    HStack{
                        Text(item.item!)
                        Spacer()
                        Button("Copy") {
                            //TODO copy to clipboard
                            let pasteboard = UIPasteboard.general
                            pasteboard.string = item.item
                            alertVisible = true
                                
                        }.alert(isPresented: $alertVisible) {
                            Alert(title: Text("Copied to Clipboard"),
                                  message: Text(item.item!),
                                  primaryButton: .default(Text("OK"), action: {
                                  }),
                                  secondaryButton: .cancel(Text("Cancel"), action: {
                                  })
                            )
                        }
                    }
                }
                .onDelete(perform: deleteItems)
            }
            Spacer()
            Button("Add") {
                actionSheetVisible = true
            }
            .padding()
            .sheet(isPresented: $actionSheetVisible) {
                VStack{
                    TextField("Placeholder", text: $newString)
                    Button("Add New"){
                        addItem(newString: newString)
                    }
                }.presentationDetents([.medium])
            }
        }
    }

    private func addItem(newString: String) {
        withAnimation {
            let newItem = Item(context: viewContext)
            
            newItem.item = newString

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(newString: "Hello world").environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
