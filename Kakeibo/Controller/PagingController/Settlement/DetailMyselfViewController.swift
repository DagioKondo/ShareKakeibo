//
//  DetailMyselfViewController.swift
//  Kakeibo
//
//  Created by 近藤大伍 on 2021/10/20.
//

import UIKit

class DetailMyselfViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var profileArray = [String]()
    var paymentArray = [String]()
    var userNameArray = [String]()
    var dateArray = [String]()
    var categoryArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height - 83 - 84 - 40)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let profileImage = cell.contentView.viewWithTag(2) as! UIImageView
        let paymentLabel = cell.contentView.viewWithTag(3) as! UILabel
        let userNameLabel = cell.contentView.viewWithTag(4) as! UILabel
        let dateLabel = cell.viewWithTag(5) as! UILabel
        let category = cell.viewWithTag(6) as! UILabel
        
        return cell
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
