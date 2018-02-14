//
//  HOLDataInitializer.swift
//  holidays
//
//  Created by MANUEL SOBERANIS on 10/02/18.
//  Copyright © 2018 com.majesova. All rights reserved.
//

import UIKit
import CoreData
class HOLIDataInitializer: NSObject {

    
    func initialize(){
        let jobName = "PLENUMSOFT";
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let context = appDelegate.persistentContainer.viewContext
        
        let jobFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Job")
        jobFetch.predicate = NSPredicate(format: "key == %@", jobName)
        
        do {
            let fetchedJObs = try context.fetch(jobFetch) as! [Job]
            if fetchedJObs.count == 0 {
                
                let job = NSEntityDescription.insertNewObject(forEntityName: "Job", into: context) as! Job
                job.key = jobName
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy/MM/dd"
                let date = formatter.date(from: "2009/08/20")
                job.hiredDate = date
                
                
                //benefit configurations
                var pivot = 4;
                for year in 1...39 {
                    let benefit = NSEntityDescription.insertNewObject(forEntityName: "BenefitConfiguration", into: context) as! BenefitConfiguration
                    benefit.year = Int16(year)
                    
                    if(year < 5){pivot += 2}
                    if(year >= 5 && year < 10){ pivot = 14 }
                    if(year >= 10 && year < 15){ pivot = 16 }
                    if(year >= 15 && year < 20){ pivot = 18 }
                    if(year >= 20 && year < 25){ pivot = 20 }
                    if(year >= 25 && year < 30){ pivot = 22 }
                    if(year >= 30 && year < 35){ pivot = 24 }
                    if(year >= 35 && year < 40){ pivot = 26 }
                    benefit.daysBenefits = Int32(pivot);
                    //print("año \(year) benefit \(pivot)")
                }
                
                //print("Data is Initialized")
            }else{
                
                //print("valores guardados")
                let job = fetchedJObs.first
                //print(job)
                //print("job name: \(job!.key!)")
                //print("job date: \(job!.hiredDate!)")
                let sort = NSSortDescriptor(key: #keyPath(BenefitConfiguration.year), ascending: true)
                let daysFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "BenefitConfiguration")
                daysFetch.sortDescriptors = [sort]
                let days = try context.fetch(daysFetch) as! [BenefitConfiguration]
                for day in days{
                    print("\(day.year),\(day.daysBenefits)")
                }
                
                
            }
            
        } catch {
            fatalError("Failed to fetch jobs: \(error)")
        }
        
        
        do{
            try context.save()
        }catch{
            print(error)
        }
       
    }
    
}
