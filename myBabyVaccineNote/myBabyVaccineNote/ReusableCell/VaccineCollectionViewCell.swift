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
        $0.setTitle("백신이름", for: .normal)
    }
    
    func setupView() {
        self.addSubview(button)
        
        button.snp.makeConstraints{
            $0.center.bottom.top.trailing.leading.equalToSuperview()
        }
    }
}
