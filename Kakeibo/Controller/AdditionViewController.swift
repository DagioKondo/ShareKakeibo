//
//  AdditionViewController.swift
//  Kakeibo
//
//  Created by 近藤大伍 on 2021/10/15.
//

import UIKit

class AdditionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    
    
    @IBOutlet weak var invitationButton: UIButton!
    @IBOutlet weak var searchUserTextField: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    var selectedUserImageArray = [String]()
    var colorArray = [UIColor.blue,UIColor.red,UIColor.green,UIColor.yellow,UIColor.purple] //あとで消す
    
    var indexPathArray = [IndexPath]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        invitationButton.layer.cornerRadius = 5
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = layout
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CollectionViewCell")
        
        selectedUserImageArray = ["person","person.fill","person","person.fill","person"]
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedUserImageArray.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        cell.profileImage!.image = UIImage(systemName: selectedUserImageArray[indexPath.row])
        cell.profileImage.backgroundColor = colorArray[indexPath.row]
        cell.deleteButton!.addTarget(self, action: #selector(tapDeleteButton(_:)), for: .touchUpInside)
        print("daigoitemAt")
        print(cell.deleteButton.tag)
        
        return cell
    }
    
    @objc func tapDeleteButton(_ sender:UIButton){
        print(sender.superview?.superview?.superview)
        print(sender.superview)
        print(sender.superview?.superview)
        let cell = sender.superview?.superview as! UICollectionViewCell
        let indexPath = collectionView.indexPath(for: cell)
        print(indexPath?.row)
        selectedUserImageArray.remove(at: indexPath!.row)
        colorArray.remove(at: indexPath!.row)
        collectionView.deleteItems(at: [IndexPath(item: indexPath!.row, section: 0)])
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
    
    
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func invitationButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
