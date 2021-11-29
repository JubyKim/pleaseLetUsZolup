//
//  ListTableViewCell.swift
//  myBabyVaccineNote
//
//  Created by JUEUN KIM on 2021/11/26.
//

import UIKit
import Then
import SnapKit

class ListTableViewCell: UITableViewCell {

    let identifier = "ListTableViewCell"
    
    let HospName = UILabel().then{
        $0.font = UIFont(name: "GillSans-SemiBold", size: 16.0)
    }
    let HospAdr = UILabel().then{
        $0.font = UIFont(name: "GillSans-SemiBold", size: 14.0)
    }
    let DisName = UILabel().then{
        $0.font = UIFont(name: "GillSans-SemiBold", size: 12.0)
    }
    
    let vacName = UILabel().then{
        $0.font = UIFont(name: "GillSans-SemiBold", size: 12.0)
    }
    let Price = UILabel().then{
        $0.font = UIFont(name: "GillSans-SemiBold", size: 12.0)
    }
    
    func makeLayout() {
        
        HospName.snp.makeConstraints{
            $0.top.equalToSuperview().offset(8)
            $0.leading.equalToSuperview().offset(8)
        }
        
//        HospAdr.snp.makeConstraints{
//            $0.top.equalTo(HospName.snp.bottom).offset(4)
//            $0.leading.equalToSuperview().offset(8)
//        }
//        DisName.snp.makeConstraints{
//            $0.top.equalTo(HospAdr.snp.bottom).offset(4)
//            $0.leading.equalToSuperview().offset(8)
//        }
//        vacName.snp.makeConstraints{
//            $0.top.equalTo(HospAdr.snp.bottom).offset(4)
//            $0.leading.equalTo(DisName.snp.trailing).offset(4)
//        }
        Price.snp.makeConstraints{
            $0.top.equalTo(HospName.snp.bottom).offset(4)
            $0.leading.equalToSuperview().offset(8)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        print("이거 불러지나~~~~ 어디보자~~~~")
        contentView.snp.makeConstraints{
//            $0.height.equalTo(40)
            $0.top.leading.trailing.equalToSuperview()
        }
        contentView.addSubview(HospName)
        contentView.addSubview(HospAdr)
        contentView.addSubview(DisName)
        contentView.addSubview(vacName)
        contentView.addSubview(Price)
//        contentView.backgroundColor = .blue
        makeLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
