//
//  CapitalizeExtension.swift
//  holidays
//
//  Created by MANUEL SOBERANIS on 13/02/18.
//  Copyright © 2018 com.majesova. All rights reserved.
//

import UIKit

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
