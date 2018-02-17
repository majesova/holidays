//
//  HOLDashboardViewController.swift
//  holidays
//
//  Created by MANUEL SOBERANIS on 15/02/18.
//  Copyright © 2018 com.majesova. All rights reserved.
//

import UIKit

class HOLDashboardViewController: BaseViewController, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var stats = [PeriodStat]()
    
    let interactor = HOLDashboardInteractor()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addSlideMenuButton()
        self.title = "Dashboard"
        collectionView.dataSource = self
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.stats = interactor.getStats()
        collectionView.reloadData()
        
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return stats.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dashboardCell", for: indexPath) as! HOLDashboardCell
        let stat = stats[indexPath.section]
        cell.lblTotal.text = "\(stat.daysOfPeriod!)"
        cell.lblUsed.text = "\(stat.usedDays!)"
        cell.lblAvailable.text = "\(stat.availableDays!)"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "dashboardHeaderView", for: indexPath) as! HOLDashboardReusableView
        let formatter = DateFormatter()
        let stat = stats[indexPath.section]
        formatter.dateFormat = "yyyy-MM-dd"
        view.lblYear.text = "\(stat.workedYears!)"
        view.lblRangeDates.text = "\(formatter.string(from: stat.startDate!))- \(formatter.string(from: stat.endDate!))"
        return view
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
