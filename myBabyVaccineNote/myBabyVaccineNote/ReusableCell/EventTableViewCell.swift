//
//  EventTableViewCell.swift
//  myBabyVaccineNote
//
//  Created by JUEUN KIM on 2021/11/02.
//

import UIKit

class EventTableViewCell: UITableViewCell {

    let identifier = "EventTableViewCell"
    let date = UILabel().then{
        $0.font = UIFont(name: "GillSans-SemiBold", size: 16.0)
        $0.backgroundColor = .yellow
    }
    let event = UILabel().then{
        $0.font = UIFont(name: "GillSans-SemiBold", size: 16.0)
        $0.backgroundColor = .red
    }
    
    func tableViewCellLayout(){
        date.snp.makeConstraints{
            $0.top.bottom.leading.equalToSuperview()
        }
        
        event.snp.makeConstraints{
            $0.top.bottom.trailing.equalToSuperview()
            $0.leading.equalTo(date.snp.trailing)
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

}
