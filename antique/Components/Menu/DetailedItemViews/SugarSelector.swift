//
//  SugarSelector.swift
//  antique
//
//  Created by Vong Beng on 19/1/20.
//  Copyright © 2020 Vong Beng. All rights reserved.
//

import SwiftUI

// Sugar Selector, different levels taken from Menu class
struct SugarSelector: View {
    @EnvironmentObject var menu : Menu
    @Binding var sugarLevel : Int
    
    var body: some View {
        Section(header:
            Text("Sugar Level")
                .padding(5)
                .foregroundColor(Styles.getColor(.darkCyan))
        ) {
            Picker("Levels:", selection: $sugarLevel) {
                ForEach(0 ..< self.menu.sugarLevels.count){
                    Text("\(self.menu.sugarLevels[$0])")
                }
            }
            .pickerStyle(SegmentedPickerStyle())
        }
    }
}

//struct SugarSelector_Previews: PreviewProvider {
//    static var previews: some View {
//        SugarSelector()
//    }
//}
