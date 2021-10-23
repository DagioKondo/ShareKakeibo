//
//  OverAllViewController.swift
//  Kakeibo
//
//  Created by 近藤大伍 on 2021/10/22.
//

import UIKit
import Charts

class OverAllViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

//        let lineChartsView = LineChartView()
        let lineChartsView = UIView()
        lineChartsView.frame = CGRect(x: 0, y: 80, width: view.frame.width, height: 350)
        lineChartsView.backgroundColor = .red
        self.view.addSubview(lineChartsView)
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
