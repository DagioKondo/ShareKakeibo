//
//  DetailLastMonthViewController.swift
//  Kakeibo
//
//  Created by 近藤大伍 on 2021/10/15.
//

import UIKit
import Parchment

class DetailLastMonthViewController: UIViewController {

    @IBOutlet weak var headerView: UIView!
    
    
    var buttonAnimatedModel = ButtonAnimatedModel(withDuration: 0.1, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, transform: CGAffineTransform(scaleX: 0.95, y: 0.95), alpha: 0.7)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let DetailAllVC = storyboard?.instantiateViewController(identifier: "DetailAllVC")
        let DetailMyselfVC = storyboard?.instantiateViewController(identifier: "DetailMyselfVC")
        
        DetailAllVC?.title = "グループ全体"
        DetailMyselfVC?.title = "個人"
        
        let pagingVC = PagingViewController(viewControllers: [
            DetailAllVC!,
            DetailMyselfVC!
        ])
     
        self.addChild(pagingVC)
        self.view.addSubview(pagingVC.view)
        pagingVC.didMove(toParent: self)
        pagingVC.view.translatesAutoresizingMaskIntoConstraints = false
        pagingVC.view.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        pagingVC.view.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        pagingVC.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        pagingVC.view.topAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
        
        pagingVC.selectedBackgroundColor = .clear
        pagingVC.indicatorColor = UIColor(red: 255 / 255, green: 190 / 255, blue: 115 / 255, alpha: 1.0)
        pagingVC.textColor = .darkGray
        pagingVC.selectedTextColor = UIColor(red: 255 / 255, green: 190 / 255, blue: 115 / 255, alpha: 1.0)
        pagingVC.menuBackgroundColor = .clear
        pagingVC.borderColor = .clear
        pagingVC.menuItemSize = .selfSizing(estimatedWidth: 100, height: 40)
        pagingVC.menuItemSpacing = 80
        pagingVC.menuHorizontalAlignment = .center
        
        print(UITableViewController().view.frame)
        print(DetailAllVC!.view.frame)
        print(DetailMyselfVC!.view.frame)
        print(pagingVC.view.frame)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
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
