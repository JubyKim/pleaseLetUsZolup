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
    
    let upperBackground = UIView().then{
        $0.backgroundColor = .blue
    }
    let profileBox = UIImageView().then{
        $0.image = UIImage(named: "profileBox")
    }
    let profilePhoto = UIImageView().then{
        $0.image = UIImage(named: "ProfileImage")
    }
    let editButton = UIButton().then{
        $0.setBackgroundImage(UIImage(named: "editButton"), for: .normal)
    }
    let shareButton = UIButton().then{
        $0.setBackgroundImage(UIImage(named: "ShareButton"), for: .normal)
    }
    let LogoutButton = UIButton().then{
        $0.setBackgroundImage(UIImage(named: "LogoutButton"), for: .normal)
    }
    let nameLabel = UILabel().then{
        $0.text  = "김슈니"
    }
    let ageLabel = UILabel().then{
        $0.text  = "만 24세"
    }
    let sexImage = UIImageView().then{
        $0.image = UIImage(named: "femaleImage")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(upperBackground)
        self.view.addSubview(profileBox)
        self.view.addSubview(profilePhoto)
        self.view.addSubview(editButton)
        self.view.addSubview(shareButton)
        self.view.addSubview(LogoutButton)
        
        allLayout()
    }
    
    func allLayout(){
        navigationController?.navigationBar.isHidden = true
        upperBackgroundLayout()
        profileBoxLayout()
        profilePhotoLayout()
        editButtonLayout()
        shareButtonLayout()
        LogoutButtonLayout()
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
            $0.leading.equalToSuperview().offset(60)
            $0.trailing.equalToSuperview().offset(-60)
            $0.centerY.equalTo(upperBackground.snp.bottom)
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
        
    }
    func ageLabelLayout(){
        
    }
    func sexImageLayout(){
        
    }
    func shareButtonLayout(){
        print(#function)
    }
    func LogoutButtonLayout(){
        print(#function)
    }
    
}
