//
//  RegisterViewController.swift
//  Kakeibo
//
//  Created by 近藤大伍 on 2021/10/15.
//

import UIKit
import Firebase
import FirebaseFirestore

class RegisterViewController: UIViewController,LoginOKDelegate,SendOKDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
   

    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var checkTextField: UITextField!
    @IBOutlet weak var errorShowLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    var loginModel = LoginModel()
    var myEmail = String()
    var sendDBModel = SendDBModel()
    var alertModel = AlertModel()
    var db = Firestore.firestore()
    
    var activityIndicatorView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        registerButton.layer.cornerRadius = 5
        profileImageView.layer.cornerRadius = 108
        loginModel.loginOKDelegate = self
        sendDBModel.sendOKDelegate = self
        
        activityIndicatorView.center = view.center
        activityIndicatorView.style = .large
        activityIndicatorView.color = .darkGray
        
        view.addSubview(activityIndicatorView)
        
        
    }
    
    @IBAction func registerButton(_ sender: Any) {
        activityIndicatorView.startAnimating()
        loginModel.register(email: emailTextField.text!, password: passwordTextField.text!, check: checkTextField.text!, errorShowLabel: errorShowLabel,activityIndicatorView: activityIndicatorView)
    }
    
    func registerOK(userID: String) {
        myEmail = userID
        
        let data = profileImageView.image?.jpegData(compressionQuality: 1.0)
        sendDBModel.sendProfileImage(data: data!)
    }
    
    func sendProfileImage_OK(url: String) {
        if url.isEmpty != true{
            db.collection("usersManagement").document(myEmail).setData(["email" : myEmail, "userName": userNameTextField.text,"password":passwordTextField.text,"profileImage":url])
            userNameTextField.text = ""
            emailTextField.text = ""
            passwordTextField.text = ""
            checkTextField.text = ""
            activityIndicatorView.stopAnimating()
            performSegue(withIdentifier: "ProfileVC", sender: nil)
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let ProfileVC = segue.destination as! ProfileViewController
        ProfileVC.myEmail = myEmail
        UserDefaults.standard.setValue(myEmail, forKey: "myEmail")
    }
    
    @IBAction func profileImageView(_ sender: UITapGestureRecognizer) {
        alertModel.satsueiAlert(viewController: self)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if info[.editedImage] as? UIImage != nil{
            let editedImage = info[.editedImage] as! UIImage
            profileImageView.image = editedImage
            picker.dismiss(animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
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
