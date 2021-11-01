//
//  ViewController.swift
//  shareKakeibo
//
//  Created by nishimaru on 2021/10/25.
//  Copyright © 2021 nishimaru. All rights reserved.
//
import UIKit

class CreateGroupViewController: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,CollectionDeligate{
    
    
    //    var collectionDeligate:CollectionDeligate?
    @IBOutlet weak var groupNameTextField: UITextField!
    @IBOutlet weak var fixedCostTextField: UITextField!
    @IBOutlet weak var settlementTextField: UITextField!
    @IBOutlet weak var searchUserButton: UIButton!
    @IBOutlet weak var createGroupButton: UIButton!
 
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var selectedUserImageArray = [String]()
    var colorArray = [UIColor]()
    var emailArray = [String]()
    
    var buttonAnimatedModel = ButtonAnimatedModel(withDuration: 0.1, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, transform: CGAffineTransform(scaleX: 0.95, y: 0.95), alpha: 0.7)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchUserButton.layer.cornerRadius = 5
        
        searchUserButton.addTarget(self, action: #selector(touchDown(_:)), for: .touchDown)
        searchUserButton.addTarget(self, action: #selector(touchUpOutside(_:)), for: .touchUpOutside)
        
        createGroupButton.layer.cornerRadius = 5
        createGroupButton.addTarget(self, action: #selector(touchDown(_:)), for: .touchDown)
        createGroupButton.addTarget(self, action: #selector(touchUpOutside(_:)), for: .touchUpOutside)
        
        collectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CollectionViewCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = layout
        
        
    }

    @objc func touchDown(_ sender:UIButton){
        buttonAnimatedModel.startAnimation(sender: sender)
    }
    
    @objc func touchUpOutside(_ sender:UIButton){
        buttonAnimatedModel.endAnimation(sender: sender)
    }
    
    @IBAction func searchUserButton(_ sender: Any) {
        buttonAnimatedModel.endAnimation(sender: sender as! UIButton)
        performSegue(withIdentifier: "searchVC", sender: nil)
       
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let searchVC = segue.destination as! SearchViewController
        searchVC.collectionDeligate = self
    }
    
    
    func SendArray(selectedUserImageArray: [String],emailArray: [String]) {
        print(selectedUserImageArray)
        print(emailArray)
        self.selectedUserImageArray = selectedUserImageArray
        self.emailArray = emailArray
        collectionView.reloadData()
        print(self.emailArray)
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
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
//        cell.profileImage.backgroundColor = colorArray[indexPath.row]
        cell.deleteButton!.addTarget(self, action: #selector(tapDeleteButton(_:)), for: .touchUpInside)
        print("daigoitemAt")
        print(cell.deleteButton.tag)
        
        return cell
    }
    
    @objc func tapDeleteButton(_ sender:UIButton){
        //        print(sender.superview?.superview?.superview)
        //        print(sender.superview)
        //        print(sender.superview?.superview)
        let cell = sender.superview?.superview as! UICollectionViewCell
        let indexPath = collectionView.indexPath(for: cell)
        print(indexPath?.row)
        selectedUserImageArray.remove(at: indexPath!.row)
        emailArray.remove(at: indexPath!.row)
        print(emailArray)
//        colorArray.remove(at: indexPath!.row)
        collectionView.deleteItems(at: [IndexPath(item: indexPath!.row, section: 0)])
    }
    
    
    @IBAction func createGroupButton(_ sender: Any) {
        buttonAnimatedModel.endAnimation(sender: sender as! UIButton)
    }
    
    
    @IBAction func back(_ sender: Any) {
        navigationController?.popViewController(animated: true)
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
