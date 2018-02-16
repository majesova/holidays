//
//  HOLCalendarInteractor.swift
//  holidays
//
//  Created by MANUEL SOBERANIS on 13/02/18.
//  Copyright © 2018 com.majesova. All rights reserved.
//

import UIKit
import CoreData

class HOLCalendarInteractor: DataInteractor {
    
 
    
    func inserDate(date:Date){
        
        let context = getContext()
        
        let holiday = NSEntityDescription.insertNewObject(forEntityName: self.entityNameHoliday, into: context) as! Holiday
        holiday.date = date
        do{
            try context.save()
        }catch{
            print(error)
        }
        
    }
    
    func isDateSaved(date:NSDate)->Bool{
        let context = getContext()
        
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
     let context = getContext()
        
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
        let context = getContext()
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
