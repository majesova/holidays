//
//  DataInteractor.swift
//  holidays
//
//  Created by MANUEL SOBERANIS on 15/02/18.
//  Copyright © 2018 com.majesova. All rights reserved.
//

import UIKit
import CoreData
class DataInteractor: NSObject {

    let entityNameHoliday = "Holiday"
    let entityNameJob = "Job"
    
    func getContext()->NSManagedObjectContext{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        return context
    }
}
