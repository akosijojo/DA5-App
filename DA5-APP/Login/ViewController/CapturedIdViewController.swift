//
//  CapturedIdViewController.swift
//  DA5-APP
//
//  Created by Jojo on 12/3/20.
//  Copyright © 2020 OA. All rights reserved.
//

import UIKit
import AVFoundation

class CapturedIdViewController: BaseViewControler, UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    weak var vc : UIViewController?
    var type : Int = 0
    
    lazy var imageView : UIImageView = {
        let v = UIImageView()
        v.layer.cornerRadius = 5
        v.backgroundColor = ColorConfig().innerbgColor
        v.layer.masksToBounds = true
        v.clipsToBounds = true
        return v
    }()
    
    lazy var retakeBtn : UIButton = {
       let v = UIButton()
        v.backgroundColor = ColorConfig().black
        v.layer.cornerRadius = 5
        v.tintColor = .white
        v.setTitle("Retake", for: .normal)
        v.titleLabel?.font = UIFont(name: Fonts.regular, size: 12)
        v.addTarget(self, action: #selector(selectImage), for: .touchUpInside)
       return v
    }()
    
    lazy var selectBtn : UIButton = {
        let v = UIButton()
        v.backgroundColor = ColorConfig().black
        v.layer.cornerRadius = 5
        v.tintColor = .white
        v.setTitle("Select", for: .normal)
        v.titleLabel?.font = UIFont(name: Fonts.regular, size: 12)
        v.addTarget(self, action: #selector(returnImageSelected), for: .touchUpInside)
        return v
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.selectImage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setUpNavigationBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.setUpView()
    }
    
    override func setUpView() {
        view.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.centerY.equalTo(view)
            if ColorConfig().screenWidth > 500 {
                make.width.equalTo(400)
                make.centerX.equalTo(view)
            }else {
                make.leading.equalTo(view).offset(20)
                make.trailing.equalTo(view).offset(-20)
            }
            make.height.equalTo(200)
        }
        
        view.addSubview(retakeBtn)
        retakeBtn.snp.makeConstraints { (make) in
            make.bottom.equalTo(view.layoutMarginsGuide.snp.bottom).offset(-20)
            make.leading.equalTo(view).offset(20)
            make.width.equalTo((ColorConfig().screenWidth - 60) / 2)
            make.height.equalTo(40)
        }
               
        view.addSubview(selectBtn)
        selectBtn.snp.makeConstraints { (make) in
            make.bottom.equalTo(view.layoutMarginsGuide.snp.bottom).offset(-20)
            make.trailing.equalTo(view).offset(-20)
            make.width.equalTo((ColorConfig().screenWidth - 60) / 2)
            make.height.equalTo(40)
        }
    }
    
    @objc func selectImage() {
        if UIImagePickerController.isSourceTypeAvailable(.camera){//.camera //.photoLibrary
            let vc = UIImagePickerController()
            vc.sourceType = .camera
//            vc.sourceType = .photoLibrary
//            vc.allowsEditing = true
            vc.delegate = self
//            vc.showsCameraControls = true
            self.present(vc, animated: true)
        }else{
            let alert = self.alert("Ok", "Camera is not Available", "", action: { (action) in
          
            })
            self.present(alert, animated: true, completion: nil)
        }
    }
    
//    func getImageFrom(sourceType: UIImagePickerController.SourceType) {
//        if UIImagePickerController.isSourceTypeAvailable(sourceType){
//             let vc = UIImagePickerController()
//                if sourceType == .camera {
//                    vc.allowsEditing = true
//                    vc.showsCameraControls = true
//                }
//                
//             vc.sourceType = sourceType
//             vc.delegate = self
//             self.present(vc, animated: true)
//         }
//    }
//    
    @objc func returnImageSelected() {
        
        if let signUpVc = vc as? SignUpViewController {
            if type == 1 {
              signUpVc.validId = self.imageView.image
            }else {
              signUpVc.selfieId = self.imageView.image
            }
        }
        
        if let profileVc = vc as? ProfileViewController {
            if type == 1 {
              profileVc.validId = self.imageView.image
            }else {
              profileVc.selfieId = self.imageView.image
            }
        }
        
        self.navigationController?.popViewController(animated: true)
    }
        
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        guard let image = info[.originalImage] as? UIImage else {
            print("No image found")
            return
        }
        // checking on show view on click select return the image in specified data
        self.imageView.image = image.landscapeOrientation()
    }
    
}
