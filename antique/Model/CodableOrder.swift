//
//  CodableOrder.swift
//  antique
//
//  File created by Vong Beng on 22/1/20.
//  Copyright © 2020 Vong Beng. All rights reserved.
//

import Foundation

struct CodableOrder : Codable, Identifiable {
    let id : UUID = UUID()
    
    var orderNo : Int
    var items : [OrderItem]
    var discPercentage : Int
    var isDiscPercentage : Bool
    var discAmountInUSD : Double
    var date : Date
    var settled : Bool
    var cancelled : Bool
    
    var subtotal: Double {
        if items.count > 0 {
            var total = 0.0
            for item in items {
                total = total + item.total
            }
            return total
        } else {
            return 0
        }
    }
    
    var total : Double {
        if isDiscPercentage {
            return subtotal * (1 - Double(discPercentage) / 100)
        } else {
            return subtotal - discAmountInUSD
        }
    }
    
    // Creates instance of CodableOrder from returned value from reading json files
    init(_ order: CodableOrderDTO) {
        self.orderNo = order.orderNo ?? 0
        self.items = order.items ?? [OrderItem]()
        self.discPercentage = order.discPercentage ?? 0
        self.isDiscPercentage = order.isDiscPercentage ?? true
        self.discAmountInUSD = order.discAmountInUSD ?? 0
        self.date = order.date ?? Date()
        self.settled = order.settled ?? false
        self.cancelled = order.cancelled ?? false
    }
    
    // Manual CodableOrder init
    init(orderNo: Int, items: [OrderItem] = [OrderItem](), discPercentage : Int = 0, isDiscPercentage : Bool = true, discAmountInUSD : Double = 0, date: Date, settled : Bool = false, cancelled : Bool = false) {
        self.orderNo = orderNo
        self.items = items
        self.discPercentage = discPercentage
        self.isDiscPercentage = isDiscPercentage
        self.discAmountInUSD = discAmountInUSD
        self.date = date
        self.settled = settled
        self.cancelled = cancelled
    }
    
    // Checks for duplicate items before adding to the ordered items array
    mutating func add(item: MenuItem, qty : Int, sugarLevel : String, iceLevel : String, upsized: Bool) {
        for (index, orderItem) in items.enumerated() {
            if(item.name == orderItem.item.name) {
                // Checks properties of the items
                if(orderItem.iceLevel == iceLevel && orderItem.sugarLevel == sugarLevel && orderItem.upsized == upsized) {
                    items[index].qty += qty
                    return
                }
            }
        }
        items.append(
            OrderItem(item: item, qty: qty, upsized: upsized, sugarLevel: sugarLevel, iceLevel: iceLevel)
        )
    }
    
    // Will remove in future iterations for text input instead
    // Increases discount percentage by 5%
    mutating func incDiscount(){
        if(discPercentage < 100) {
            discPercentage += 5
        }
    }
    // Decreases discount
    mutating func decDiscount(){
        if(discPercentage > 0) {
            discPercentage -= 5
        }
    }
    
    // Sets cancelled to true and unsettles the order
    mutating func cancel(){
        self.cancelled = true
        self.settled = false
    }
    mutating func uncancel() {
        self.cancelled = false
        self.settled = false
    }
    
    // Settles/Unsettles Order
    mutating func settle() {
        self.settled = true
        self.cancelled = false
    }
    
    mutating func unsettle() {
        self.settled = false
        self.cancelled = false
    }
}

// Data Transfer Object for reading JSON files
struct CodableOrderDTO : Codable {
    var orderNo : Int?
    var items : [OrderItem]?
    var discPercentage : Int?
    var isDiscPercentage : Bool?
    var discAmountInUSD: Double?
    var date : Date?
    var settled : Bool?
    var cancelled : Bool?
    
    init() {
        orderNo = 1
        items = [OrderItem]()
        discPercentage = 0
        isDiscPercentage = true
        discAmountInUSD = 0
        date = Date()
        settled = false
        cancelled = false
    }
    
    init(orderNo: Int = -1, items: [OrderItem] = [OrderItem](), discPercentage: Int = 0, isDiscPercentage: Bool = true, discAmountInUSD: Double = 0, date: Date = Date(), settled: Bool = false, cancelled: Bool = false) {
        self.orderNo = orderNo
        self.items = items
        self.discPercentage = discPercentage
        self.isDiscPercentage = isDiscPercentage
        self.discAmountInUSD = discAmountInUSD
        self.date = date
        self.settled = settled
        self.cancelled = cancelled
    }
    
    init(from decoder: Decoder) throws {
        let newJSON = try decoder.container(keyedBy: NewKeys.self)
        orderNo = try? newJSON.decode(Int.self, forKey: .orderNo)
        if let orderedItems = try? newJSON.decodeIfPresent([OrderItem].self, forKey: .items){
            items = orderedItems
        } else {
            let oldJSON = try decoder.container(keyedBy: OldKeys.self)
            items = try? oldJSON.decode([OrderItem].self, forKey: .itemsOrdered)
        }
        discPercentage = try? newJSON.decode(Int.self, forKey: .discPercentage)
        isDiscPercentage = try? newJSON.decode(Bool.self, forKey: .isDiscPercentage)
        discAmountInUSD = try? newJSON.decode(Double.self, forKey: .discAmountInUSD)
        date = try? newJSON.decode(Date.self, forKey: .date)
        settled = try? newJSON.decode(Bool.self, forKey: .settled)
        cancelled = try? newJSON.decode(Bool.self, forKey: .cancelled)
    }
    
    private enum NewKeys : String, CodingKey {
        case orderNo
        case items
        case discPercentage
        case isDiscPercentage
        case discAmountInUSD
        case date
        case settled
        case cancelled
    }
    
    private enum OldKeys : String, CodingKey {
        case orderNo
        case itemsOrdered
        case discPercentage
        case isDiscPercentage
        case discAmountInUSD
        case date
        case settled
        case cancelled
    }
}