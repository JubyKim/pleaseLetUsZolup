//
//  MyPageViewController.swift
//  myBabyVaccineNote
//
//  Created by JUEUN KIM on 2021/10/13.
//

import UIKit
import Then
import SnapKit

class MyPageViewController: UIViewController {
    
    let picker = UIImagePickerController()
    
    let upperBackground = UIView().then{
        $0.backgroundColor = UIColor(red: 144/255, green: 202/255, blue: 249/255, alpha: 1.0)
    }
    let profileBox = UIImageView().then{
        $0.image = UIImage(named: "profileBox")
    }
    let profilePhoto = UIImageView().then{
        $0.image = UIImage(named: "ProfileImage")
    }
    let editButton = UIButton().then{
        $0.setBackgroundImage(UIImage(named: "editButton"), for: .normal)
        $0.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
    }
    let shareButton = UIButton().then{
        $0.setBackgroundImage(UIImage(named: "ShareButton"), for: .normal)
    }
    let LogoutButton = UIButton().then{
        $0.setBackgroundImage(UIImage(named: "LogoutButton"), for: .normal)
    }
    let nameLabel = UILabel().then{
        $0.text  = "김슈니"
        $0.font = UIFont(name: "GillSans-SemiBold", size: 40.0)
    }
    let ageLabel = UILabel().then{
        $0.text  = "만 24세"
        $0.font = UIFont(name: "GillSans-SemiBold", size: 16.0)
    }
    let sexImage = UIImageView().then{
        $0.image = UIImage(named: "femaleImage")
    }
    
    override func viewDidLoad() {
        navigationController?.navigationBar.isHidden = true
        super.viewDidLoad()
        self.view.addSubview(upperBackground)
        self.view.addSubview(profileBox)
        self.view.addSubview(profilePhoto)
        self.view.addSubview(nameLabel)
        self.view.addSubview(sexImage)
        self.view.addSubview(ageLabel)
        self.view.addSubview(editButton)
        self.view.addSubview(shareButton)
        self.view.addSubview(LogoutButton)
        
        picker.delegate = self
        
        
        allLayout()
    }
    
    func allLayout(){
        
        upperBackgroundLayout()
        profileBoxLayout()
        profilePhotoLayout()
        shareButtonLayout()
        LogoutButtonLayout()
        editButtonLayout()
        nameLabelLayout()
        ageLabelLayout()
        sexImageLayout()
        
        
    }
    func upperBackgroundLayout(){
        upperBackground.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview()
            $0.top.equalToSuperview()
            $0.height.equalTo(300)
        }
    }
    
    func profileBoxLayout(){
        profileBox.snp.makeConstraints{
            $0.leading.equalToSuperview().offset(30)
            $0.trailing.equalToSuperview().offset(-30)
            $0.centerY.equalTo(upperBackground.snp.bottom)
            $0.height.equalTo(130)
        }
    }
    
    func profilePhotoLayout(){
        profilePhoto.snp.makeConstraints{
            $0.bottom.equalTo(profileBox.snp.top).offset(30)
            $0.centerX.equalTo(profileBox)
        }
    }
    func editButtonLayout(){
        editButton.snp.makeConstraints{
            $0.bottom.equalTo(profilePhoto.snp.bottom).offset(-8)
            $0.centerX.equalTo(profileBox).offset(50)
        }
    }
    func nameLabelLayout(){
        nameLabel.snp.makeConstraints{
            $0.centerX.equalTo(profileBox)
            $0.top.equalTo(profileBox.snp.top).offset(30)
        }
        print(#function)
    }
    func ageLabelLayout(){
        ageLabel.snp.makeConstraints{
            $0.centerX.equalTo(profileBox)
            $0.top.equalTo(nameLabel.snp.bottom).offset(8)
        }
        print(#function)
    }
    func sexImageLayout(){
        print(#function)
        sexImage.snp.makeConstraints{
            $0.leading.equalTo(nameLabel.snp.trailing).offset(10)
        }
    }
    func shareButtonLayout(){
        shareButton.snp.makeConstraints{
            $0.trailing.equalTo(view.safeAreaInsets.right).offset(-8)
            $0.top.equalTo(view.safeAreaInsets.top).offset(40)
        }
        print(#function)
    }
    func LogoutButtonLayout(){
        print(#function)
    }
    
    func openLibrary(){
        picker.sourceType = .photoLibrary
        present(picker, animated: false, completion: nil)
    }
    
    func openCamera(){
        picker.sourceType = .camera
        present(picker, animated: false, completion: nil)
    }
    
    @objc func editButtonTapped(){
        let alert =  UIAlertController(title: "어디서 사진을 가져올까요?", message: "어디어디", preferredStyle: .actionSheet)
        let library =  UIAlertAction(title: "사진앨범", style: .default) { (action) in self.openLibrary()}
        
        let camera =  UIAlertAction(title: "카메라", style: .default) { (action) in self.openCamera()}
        
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alert.addAction(library)
        
        alert.addAction(camera)
        
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
    }
}

extension MyPageViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            profilePhoto.image = image
            print(info)
            
        }
        
        dismiss(animated: true, completion: nil)
        
    }
    
}

