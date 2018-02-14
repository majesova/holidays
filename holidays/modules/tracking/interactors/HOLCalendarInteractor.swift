//
//  HOLCalendarInteractor.swift
//  holidays
//
//  Created by MANUEL SOBERANIS on 13/02/18.
//  Copyright © 2018 com.majesova. All rights reserved.
//

import UIKit
import CoreData

class HOLCalendarInteractor: NSObject {
    
    let entityNameHoliday = "Holiday"
    let entityNameJob = "Job"
    
    func inserDate(date:Date){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let holiday = NSEntityDescription.insertNewObject(forEntityName: self.entityNameHoliday, into: context) as! Holiday
        holiday.date = date
        do{
            try context.save()
        }catch{
            print(error)
        }
        
    }
    
    func isDateSaved(date:NSDate)->Bool{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let holidayFetch = NSFetchRequest<NSFetchRequestResult>(entityName: entityNameHoliday)
        holidayFetch.predicate = NSPredicate(format: "date == %@", date)
        
        do {
            let fetchedHolidays = try context.fetch(holidayFetch) as! [Holiday]
            return fetchedHolidays.count > 0
        
        } catch {
            fatalError("Failed to fetch holiday: \(error)")
        }
    }
    
    func removeDate(date:NSDate){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let holidayFetch = NSFetchRequest<NSFetchRequestResult>(entityName: entityNameHoliday)
        holidayFetch.predicate = NSPredicate(format: "date == %@", date)
        
        do {
            let fetchedHolidays = try context.fetch(holidayFetch) as! [Holiday]
            let holiday = fetchedHolidays.first!
            context.delete(holiday)
            
            try context.save()
            
            print("removed \(date)")
        } catch {
            fatalError("Failed to delete holiday: \(error)")
        }
    }
    
    func getHiredDate()->Date{
        let jobName = "PLENUMSOFT";
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let context = appDelegate.persistentContainer.viewContext
        
        let jobFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Job")
        jobFetch.predicate = NSPredicate(format: "key == %@", jobName)
        do {
            let job = try context.fetch(jobFetch) as! [Job]
            return job.first!.hiredDate!
        } catch {
            fatalError("Failed to delete holiday: \(error)")
        }
        
    }
    
}
