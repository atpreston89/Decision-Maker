//
//  ContentView.swift
//  Decision Maker
//
//  Created by Aaron Preston on 3/27/22.
//

import SwiftUI

struct ContentView: View {
    @State private var optionInput: String = ""
    @State private var optionList: [String] = [String]()
    @State private var optionAlert = false
    @State private var optionAlert2 = false
    @FocusState private var isFieldFocused: Bool
    
    var body: some View {
        ZStack {
            Color.gray.edgesIgnoringSafeArea(.all)
            VStack {
                Text("Decision Maker")
                    .font(.largeTitle).foregroundColor(Color.black)
                Spacer()
                
                Text("Enter the options for consideration")
                    .font(.subheadline).foregroundColor(Color.black)
                List {
                    Section {
                        TextField("Option \(optionList.count+1)", text: $optionInput, onCommit: {
                            isFieldFocused = true
                        })
                        .onSubmit({
                            if optionInput != "" {
                                optionList.append(optionInput)
                                optionInput = ""
                            } else {
                                optionAlert2 = true
                            }
                        })
                        .focused($isFieldFocused)
                        .alert( "Please enter some text", isPresented: $optionAlert2) {
                            Button("OK") {}
                        }
                    }
                    Section {
                        ForEach(optionList, id: \.self) { option in Text(option)
                        }
                        .onDelete(perform: deleteOptions)
                        .onMove(perform: moveOptions(source:destination:))
                    }
                }
                Button("Perform magic selection") {
                    optionAlert = true
                }
                .foregroundColor(Color.black)
                .alert(optionList.randomElement() ?? "Please enter choices", isPresented: $optionAlert) {
                    Button("OK", role: .cancel) {optionList.removeAll()}
                } .toolbar {
                    ToolbarItemGroup(placement: .keyboard) {
                        Spacer()
                        EditButton()
                        Button("Finish") {
                            isFieldFocused = false
                        }
                    }
                }.onAppear() {
                    UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
                    
                    AppDelegate.orientationLock = .portrait
                }.onDisappear() {
                    AppDelegate.orientationLock = .all
                }
            }
        }
    }
    func deleteOptions(at offsets: IndexSet) {
        optionList.remove(atOffsets: offsets)
    }
    func moveOptions(source: IndexSet, destination: Int) {
        optionList.move(fromOffsets: source, toOffset: destination)
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


