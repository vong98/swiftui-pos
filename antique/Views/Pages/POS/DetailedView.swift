//
//  DetailedView.swift
//  antique
//
//  Created by Vong Beng on 23/12/19.
//  Copyright © 2019 Vong Beng. All rights reserved.
//

import SwiftUI

struct DetailedView: View {
    @EnvironmentObject var order : Order
    @EnvironmentObject var menu : Menu
    @Environment(\.presentationMode) var presentationMode
    
    var item : MenuItem
    @State private var qty : Int = 1
    @State private var upsized : Bool = false
    @State private var sugarLevel : Int = 4
    @State private var iceLevel : Int = 2
    @State private var specialDiscounted : Bool = false
    
    private var total : Double {
        var tot : Double
        if upsized {
            tot = (item.price + item.upsizePrice) * Double(qty)
        } else {
            tot = Double(qty) * item.price
        }
        if specialDiscounted {
            tot = tot - (self.item.specialDiscount * Double(self.qty))
        }
        return tot
    }
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            DetailedItemTitle(item: item, total: self.total)
            HStack() {
                VStack(alignment: .leading, spacing: 10) {
                    // Upsize
                    if(self.item.canUpsize) {
                        UpsizeItem(upsized: $upsized)
                        Text(String(format: "+$%0.02f ea", self.item.upsizePrice))
                            .font(.caption)
                    }
                    // Special Discount
                    SpecialDiscountItem(specialDiscounted: self.$specialDiscounted)
                    Text(String(format: "-$%.02f ea", self.item.specialDiscount))
                        .font(.caption)
                }
                
                Spacer().frame(width: 40)
                
                QtyUpdater(qty: $qty)
            }
            
            if(self.item.hasSugarLevels) {
                Spacer().frame(height: 10)
                // Sugar Levels
                SugarSelector(sugarLevel: $sugarLevel)
            }
            
            if(self.item.hasIceLevels && self.menu.iceLevels[self.item.iceLevelIndex].count > 1) {
                Spacer().frame(height: 10)
                // Ice Levels
                IceSelector(iceLevel: $iceLevel, item: self.item)
            }
            
            Spacer().frame(height: 30)
            
            // Add to Order
            HStack {
                Spacer()
                Button(action: addToOrder) {
                    Text("Add to Order")
                        .font(.headline)
                        .padding(10)
                        .foregroundColor(Color.white)
                }
                .background(Styles.getColor(.brightCyan))
                .cornerRadius(20)
                Spacer()
            }
            Spacer()
        }
        .padding(20)
    }
    func addToOrder() {
        let sugar : String
        let ice : String
        if(self.item.hasSugarLevels) {
            sugar = self.menu.sugarLevels[self.sugarLevel]
        } else {
            sugar = "0%"
        }
        
        if(self.item.hasIceLevels) {
            if(self.item.iceLevelIndex == 0) {
                ice = "Hot"
            } else {
                ice = self.menu.iceLevels[self.iceLevel][Int(self.iceLevel)]
            }
        } else {
            ice = "None"
        }
        
        let newOrderItem = OrderItem(item: self.item, qty: self.qty, upsized: self.upsized, specialDiscounted: self.specialDiscounted, sugarLevel: sugar, iceLevel: ice)
        order.add(newOrderItem)
        order.date = Date()
        self.presentationMode.wrappedValue.dismiss()
    }
}

struct DetailedView_Previews: PreviewProvider {
    static var previews: some View {
        DetailedView(item: MenuItem())
    }
}
