//
//  LastMonthDataViewController.swift
//  Kakeibo
//
//  Created by 近藤大伍 on 2021/10/15.
//

import UIKit
import Charts

class LastMonthDataViewController: UIViewController {

    @IBOutlet weak var showDetailButton: UIButton!
    @IBOutlet weak var pieChartView: PieChartView!
    
    var graphModel = GraphModel()
    var categorypay = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        showDetailButton.layer.cornerRadius = 5
        
        categorypay = [10,10,10,10,19,3,24]
        graphModel.setPieCht(piecht: pieChartView, categorypay: categorypay)
    }
    
    @IBAction func showDetailButton(_ sender: Any) {
        performSegue(withIdentifier: "DetailLastMonthVC", sender: nil)
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
