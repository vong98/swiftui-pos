//
//  ItemOrdered.swift
//  antique
//
//  Created by Vong Beng on 13/1/20.
//  Copyright © 2020 Vong Beng. All rights reserved.
//

import Foundation

struct ItemOrdered : Identifiable {
    let id = UUID()
    var item: MenuItem
    var qty : Int = 0
}
