//
//  jimmyApp.swift
//  jimmy
//
//  Created by Jonathan Foucher on 16/02/2022.
//

import SwiftUI
import Foundation


@main
struct jimmyApp: App {
    
    let tabs = TabList()
    let bookmarks = Bookmarks()
    let store = UserDefaults()


    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(bookmarks)
                .frame(maxWidth: .infinity, minHeight: 200, alignment: .center)
                .onOpenURL(perform: {url in
                    print(url)
                })
                .onAppear(perform: {
                    DispatchQueue.main.async {
                        guard let firstWindow = NSApp.windows.first(where: { win in
                            return NSStringFromClass(type(of: win)) == "SwiftUI.SwiftUIWindow"
                        }) else { return }

                        //firstWindow.makeKeyAndOrderFront(nil)
                        var group = firstWindow
                        if let g = firstWindow.tabGroup?.selectedWindow {
                            group = g
                        }

                        var lastWindow = NSApp.windows.first(where: {win in
                            return win.tabbedWindows?.count == nil && NSStringFromClass(type(of: win)) == "SwiftUI.SwiftUIWindow" && win != group
                        })

                        NSApp.windows.forEach({win in
                            let className = NSStringFromClass(type(of: win))
                            if win != firstWindow && className == "SwiftUI.SwiftUIWindow" && win.tabbedWindows?.count == nil {
                                print("adding window", win)

                                group.addTabbedWindow(win, ordered: .above)
                            }
                        })

                        if let last = lastWindow {
                            print("last tWindow", last)
                            last.makeKeyAndOrderFront(nil)
                        }

                    }
                })
                
        }
        .handlesExternalEvents(matching: ["*"])
        .windowStyle(.titleBar)
    
        .windowToolbarStyle(.unified(showsTitle: false))
        .commands(content: {
            CommandGroup(replacing: .newItem) {
                CommandsView()
                
            }
        })
        .defaultAppStorage(Store())
            
    }
    


}

class Store: UserDefaults {
    override func set(_ value: Int, forKey defaultName: String) {
    }
}
