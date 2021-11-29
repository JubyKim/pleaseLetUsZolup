//
//  VaccineCollectionViewCell.swift
//  myBabyVaccineNote
//
//  Created by JUEUN KIM on 2021/09/29.
//

import UIKit
import Then
import SnapKit

class VaccineCollectionViewCell: UICollectionViewCell {
    let button = UIButton().then{
        $0.isUserInteractionEnabled = false
//        $0.addTarget(self, action: #selector(vaccineButtonTapped), for: .touchUpInside)
//        $0.sizeToFit()
    }
    
    let buttonName = UILabel().then{
        $0.textColor = .black
        $0.isUserInteractionEnabled = false
    }
    
//    @objc func vaccineButtonTapped(){
//            let alert = UIAlertController(title: "비급여 진료비 확인 서비스 대상입니다.", message: """
//                92%의 확률로 환불이 가능한 항목입니다.
//                해당 서비스를 신청하시려면 서류제출하기 버튼을 눌러주세요.
//                """, preferredStyle: .alert)
//            let defaultAction = UIAlertAction(title: "OK", style: .destructive, handler : nil)
//            alert.addAction(defaultAction)
//    }

    
    func setupView() {
        self.addSubview(button)
        self.backgroundColor = nil

        self.addSubview(buttonName)
        
        button.snp.makeConstraints{
            $0.center.bottom.top.trailing.leading.equalToSuperview()
//            $0.width.equalTo(70)
        }
        
        buttonName.snp.makeConstraints{
            $0.leading.trailing.top.bottom.equalToSuperview()
        }
        button.titleLabel?.sizeToFit()
    }
}
