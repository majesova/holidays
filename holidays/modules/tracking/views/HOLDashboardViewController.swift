//
//  HOLDashboardViewController.swift
//  holidays
//
//  Created by MANUEL SOBERANIS on 15/02/18.
//  Copyright © 2018 com.majesova. All rights reserved.
//

import UIKit

class HOLDashboardViewController: BaseViewController {

    let interactor = HOLDashboardInteractor()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addSlideMenuButton()
        self.title = "Dashboard"
        interactor.getStats()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
