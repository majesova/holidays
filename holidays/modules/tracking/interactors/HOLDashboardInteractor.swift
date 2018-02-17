//
//  HOLDashboardInteractor.swift
//  holidays
//
//  Created by MANUEL SOBERANIS on 15/02/18.
//  Copyright © 2018 com.majesova. All rights reserved.
//

import UIKit
import CoreData
class HOLDashboardInteractor: DataInteractor {

    
    
    func getNumberOfDaysInPeriods()->[Int: Int]{
        var dictionary = [Int: Int]()
        let context = getContext()
        //Obtenemos las fechas de los periodos
        
        let daysFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "BenefitConfiguration")
        do
        {
            let benefits = try context.fetch(daysFetch) as! [BenefitConfiguration]
            for benefit in benefits {
                dictionary[Int(benefit.year)] = Int(benefit.daysBenefits)
            }
        }
        catch {
            fatalError("Failed to fetch benefits: \(error)")
        }
        return dictionary
    }
    
    
    func getStats()->[PeriodStat]{
        let benefits = getNumberOfDaysInPeriods()
        let context = getContext()
        //Obtenemos las fechas de los periodos
        
        let jobFetch = NSFetchRequest<NSFetchRequestResult>(entityName: entityNameJob)
        
        do {
            var hiredDate :Date
            let fetchedJobs = try context.fetch(jobFetch) as! [Job]
            
            if fetchedJobs.count > 0{
                hiredDate = fetchedJobs.first!.hiredDate!
                print("hired: \(hiredDate)")
                let calendar = NSCalendar.current
                let components = calendar.dateComponents([.year], from: hiredDate, to: Date())
                let yearsWorked = components.year
                
                
                var periodStats = [PeriodStat]()
                for periodNumber in 1...yearsWorked!{
                    let periodStat = PeriodStat()
                    periodStat.workedYears = periodNumber
                    var dateComponentPeriod = DateComponents()
                    dateComponentPeriod.year = periodNumber
                    dateComponentPeriod.day = 1
                    periodStat.startDate = Calendar.current.date(byAdding: dateComponentPeriod, to: hiredDate)
                    var dateComponentOneyear = DateComponents()
                    dateComponentOneyear.year = 1
                 
                    let endDate = Calendar.current.date(byAdding: dateComponentOneyear, to: periodStat.startDate!)
                    periodStat.endDate = endDate
                    periodStat.daysOfPeriod = benefits[periodNumber] ?? 0
                    
                    //aumenta un día
                    var dateComponentDay = DateComponents()
                    dateComponentDay.day = -1
                    periodStat.endDate = Calendar.current.date(byAdding: dateComponentDay, to: periodStat.endDate!)
                
                    //fill used
                    periodStat.usedDays = getNumberOfVacationsBetweenDates(startDate: periodStat.startDate! as NSDate, endDate: periodStat.endDate! as NSDate)
                    
                    //fill available
                    periodStat.availableDays = periodStat.daysOfPeriod! - periodStat.usedDays!
                    periodStats.append(periodStat)
                    
                }
                
                periodStats = periodStats.sorted(by: { (p1, p2) -> Bool in
                    p1.workedYears! > p2.workedYears!
                })
                return periodStats
                for p in periodStats{
                    print("\(p.workedYears!), \(p.startDate!) ,\(p.endDate!), \(p.daysOfPeriod!), \(p.usedDays!), \(p.availableDays!)")
                }
            }
            
        } catch {
            fatalError("Failed to fetch holiday: \(error)")
        }
     
        return [PeriodStat]()
    }
    
    func getNumberOfVacationsBetweenDates(startDate:NSDate, endDate:NSDate)->Int{
        
        let context = getContext()
        let datesFetch = NSFetchRequest<NSFetchRequestResult>(entityName: entityNameHoliday)
        
        datesFetch.predicate = NSPredicate(format: "(date >= %@) AND (date <= %@)", startDate, endDate)
        do{
            let count = try context.count(for: datesFetch)
            return count
            
        }catch{
            fatalError("Failed to fetch benefits: \(error)")
        }
        
    }
}
