//
//  CalendarViewController.swift
//  holidays
//
//  Created by MANUEL SOBERANIS on 11/02/18.
//  Copyright © 2018 com.majesova. All rights reserved.
//

import UIKit
import JTAppleCalendar

class HOLCalendarViewController: UIViewController {

    let outsideMonthColor = UIColor(hexString: "0x584a66")
    let monthColor = UIColor.white
    let selectedMonthColor = UIColor(hexString: "0x3a294b")
    let currentDateSelectedViewColor = UIColor(hexString: "0x4e3f5d")
    let interactor = HOLCalendarInteractor()
    
    
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    
    
    @IBOutlet weak var labelYear: UILabel!
    
    @IBOutlet weak var labelMonth: UILabel!
    
    let formatter = DateFormatter()
    
    
    func setupCalendarView(){
        calendarView.minimumLineSpacing = 0
        calendarView.minimumInteritemSpacing = 0
        
        calendarView.scrollToDate(Date())
        
        calendarView.visibleDates{(visibleDates) in
            self.setupViewsOfCalendar(from: visibleDates)
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCalendarView()
        
        calendarView.calendarDelegate = self
        calendarView.calendarDataSource = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func handleCellTextColor(view: HOLCalendarCell, cellState: CellState){
            if cellState.dateBelongsTo == .thisMonth && cellState.day != .sunday && cellState.day != .saturday {
                view.dateLabel.textColor = UIColor.black
            }else{
                view.dateLabel.textColor = UIColor.lightGray
            }
    }
   
    
    func setupViewsOfCalendar(from visibleDates: DateSegmentInfo){
        let date = visibleDates.monthDates.first!.date
        formatter.dateFormat = "yyyy"
        labelYear.text = " " + formatter.string(from: date).capitalizingFirstLetter()
        formatter.dateFormat = "MMMM"
        labelMonth.text = " " + formatter.string(from: date).capitalizingFirstLetter()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
    func selectDate(cell:HOLCalendarCell, cellState: CellState){
        cell.selectedView.layer.cornerRadius = 20
        cell.selectedView.isHidden = false
    }
    
    func unselectDate(cell:HOLCalendarCell, cellState: CellState){
        cell.selectedView.layer.cornerRadius = 20
        cell.selectedView.isHidden = true
    }
    
    func isValidDate(cellState: CellState)->Bool{
        if cellState.dateBelongsTo == .thisMonth && cellState.day != .sunday && cellState.day != .saturday  {
            return true
        }else{
            return false
        }
    }
    
}


extension HOLCalendarViewController : JTAppleCalendarViewDelegate, JTAppleCalendarViewDataSource{
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        
    }
    
    
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        formatter.dateFormat = "dd MM yyyy"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        let hiredDate = interactor.getHiredDate()
        
        var dateComponent = DateComponents()
        dateComponent.year = 1
        let startDate = Calendar.current.date(byAdding: dateComponent, to: hiredDate)
        var dateComponentEnd = DateComponents()
        
        dateComponentEnd.year = 1
        let endDate = Calendar.current.date(byAdding: dateComponentEnd, to: Date())
        let parameters = ConfigurationParameters(startDate: startDate!, endDate: endDate!)
        
        return parameters
    }
    
    //Delegate parameters
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CalendarCell", for: indexPath) as! HOLCalendarCell
        cell.dateLabel.text = cellState.text
        
        handleCellTextColor(view: cell, cellState: cellState)
        
        if interactor.isDateSaved(date: date as NSDate){
            selectDate(cell: cell, cellState: cellState)
        }else{
            unselectDate(cell: cell, cellState: cellState)
        }
        return cell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        guard let validCell = cell as? HOLCalendarCell else {return}
        //text color
        handleCellTextColor(view: validCell, cellState: cellState)
        //actions
        if isValidDate(cellState: cellState){
            if interactor.isDateSaved(date: date as NSDate) == false {
                interactor.inserDate(date: date)
                selectDate(cell: validCell, cellState: cellState)
            }else{
                interactor.removeDate(date: date as NSDate)
                unselectDate(cell: validCell, cellState: cellState)
            }
        }else{
            
        }
        
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        setupViewsOfCalendar(from: visibleDates)
        self.calendarView.reloadData()
    }
    
    
}
