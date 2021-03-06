//
//  DetailItemTitle.swift
//  antique
//
//  Created by Vong Beng on 19/1/20.
//  Copyright © 2020 Vong Beng. All rights reserved.
//

import SwiftUI

// Title for DetailedView
struct DetailedItemTitle: View {
    var item : MenuItem
    var total : Double = 0
    
    var body: some View {
        HStack{
            Text(item.name)
                .font(.system(size: 40))
                .fontWeight(.bold)
                .foregroundColor(Styles.getColor(.darkGrey))
            
            Spacer()
            
            Text(String(format: "$%.02f", self.total))
                .font(.system(size: 30))
                .fontWeight(.bold)
                .foregroundColor(Styles.getColor(.darkGrey))
        }
    }
}

struct DetailedItemTitle_Previews: PreviewProvider {
    static let item = MenuItem(name: "Test", price: 2.25)
    static var previews: some View {
        DetailedItemTitle(item: item)
    }
}
