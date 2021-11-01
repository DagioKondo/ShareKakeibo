//
//  OverAllViewController.swift
//  Kakeibo
//
//  Created by 近藤大伍 on 2021/10/22.
//

import UIKit
import Charts

class OverAllViewController: UIViewController {

    var graphModel = GraphModel()
    var yAxisValues = [Int]()
    let lineChartsView = LineChartView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        yAxisValues = [200000,100000,290000,300000,200000,100000,290000,300000,200000,100000,290000,300000]
        
        
        graphModel.setLineCht(linechart: lineChartsView, yAxisValues: yAxisValues)
        lineChartsView.frame = CGRect(x: 0, y: 80, width: view.frame.width, height: 350)
        graphModel.setLineCht(linechart: lineChartsView, yAxisValues: yAxisValues)
        self.view.addSubview(lineChartsView)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        <#code#>
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
