//
//  ContentView.swift
//  PoGoStrings
//
//  Created by Stephen Wiggins on 2023-05-30.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.item, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    
    @State var newString: String = String()
    @State var actionSheetVisible = false
    @State var alertVisible = false
    @FocusState private var addNewFocused: Bool
    
    var body: some View {
        VStack{
            Text("PoGo Strings")
                .font(.title).padding(.top, 10.0)
            List{
                ForEach(items) { item in
                    HStack{
                        Text(item.item!).padding(.leading, 5)
                        Spacer()
                        Button("Copy") {
                            let pasteboard = UIPasteboard.general
                            pasteboard.string = item.item
                            alertVisible = true
                        }.buttonStyle(.bordered)
                    }
                }
                .onDelete(perform: deleteItems)
            }.scrollContentBackground(/*@START_MENU_TOKEN@*/.automatic/*@END_MENU_TOKEN@*/).scrollDismissesKeyboard(/*@START_MENU_TOKEN@*/.automatic/*@END_MENU_TOKEN@*/).listStyle(PlainListStyle())
            Spacer()
            HStack{
                TextField("New String", text: $newString)
                    .padding(.leading, 5.0).textFieldStyle(.roundedBorder).focused($addNewFocused)
                Spacer()
                Button("Add New"){
                    addItem(newString: newString)
                    newString = " "
                    addNewFocused = false
                }.padding(.trailing, 5.0).buttonStyle(.bordered)
                
            }
            .padding(.bottom, 20.0)
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
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
