//
//  MenuViewEditing.swift
//  antique
//
//  Created by Vong Beng on 19/01/20.
//  Copyright © 2020 Vong Beng. All rights reserved.
//

import SwiftUI

struct MenuViewEditing: View {
    @EnvironmentObject var menu : Menu
    
    @Binding var items : [OrderItem]

    var body: some View {
        NavigationView {
            if menu.items.count != 0 {
                List {
                    ForEach(menu.items) { section in
                        Section(header: Text(section.name)) {
                            ForEach(section.items) { item in
                                ItemRowOrderEditing(items: self.$items, item: item)
                            }
                        }
                    }
                }
                .navigationBarTitle("Menu")
                .listStyle(GroupedListStyle())
            } else {
                Text("No Items, Please Reset Menu in Admin View")
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

//struct MenuView_Previews: PreviewProvider {
//    static var previews: some View {
//        MenuView()
//    }
//}
