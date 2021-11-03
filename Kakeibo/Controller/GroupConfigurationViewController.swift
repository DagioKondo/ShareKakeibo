//
//  GroupConfigurationViewController.swift
//  Kakeibo
//
//  Created by 近藤大伍 on 2021/10/15.
//

import UIKit
import FirebaseFirestore
import CropViewController

class GroupConfigurationViewController: UIViewController,LoadOKDelegate,CropViewControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var groupNameTextField: UITextField!
    @IBOutlet weak var settelementDayTextField: UITextField!
    @IBOutlet weak var changeButton: UIButton!
    @IBOutlet weak var groupImageView: UIImageView!
    
    var db = Firestore.firestore()
    var myEmail = String()
    var groupID = String()
    
    var alertModel = AlertModel()
    
    var buttonAnimatedModel = ButtonAnimatedModel(withDuration: 0.1, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, transform: CGAffineTransform(scaleX: 0.95, y: 0.95), alpha: 0.7)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        changeButton.layer.cornerRadius = 5
        changeButton.addTarget(self, action: #selector(touchDown(_:)), for: .touchDown)
        changeButton.addTarget(self, action: #selector(touchUpOutside(_:)), for: .touchUpOutside)
    }
    
    @objc func touchDown(_ sender:UIButton){
        buttonAnimatedModel.startAnimation(sender: sender)
    }
    
    @objc func touchUpOutside(_ sender:UIButton){
        buttonAnimatedModel.endAnimation(sender: sender)
    }
    
    @IBAction func changeButton(_ sender: Any) {
        db.collection(myEmail).document(groupID).updateData(["groupName" : "\(groupNameTextField.text)" as String,"settlementDay" : "\(settelementDayTextField.text)" as String])
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func groupImageView(_ sender: Any) {
        alertModel.satsueiAlert(viewController: self)
    }
    
    @IBAction func groupImageViewButton(_ sender: Any) {
        alertModel.satsueiAlert(viewController: self)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if info[.originalImage] as? UIImage != nil{
            let pickerImage = info[.originalImage] as! UIImage
            let cropController = CropViewController(croppingStyle: .default, image: pickerImage)
        
            cropController.delegate = self
            cropController.customAspectRatio = groupImageView.frame.size
            //cropBoxのサイズを固定する。
            cropController.cropView.cropBoxResizeEnabled = false
            //pickerを閉じたら、cropControllerを表示する。
            picker.dismiss(animated: true) {
                self.present(cropController, animated: true, completion: nil)
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        //トリミング編集が終えたら、呼び出される。
        self.groupImageView.image = image
        cropViewController.dismiss(animated: true, completion: nil)
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
