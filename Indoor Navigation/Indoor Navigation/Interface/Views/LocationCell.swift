//
//  LocationCell.swift
//  Indoor Navigation
//
//  Created by Maxim Sidorov & Dmitriy Zhbannikov on 14.06.2020.
//  Copyright © 2020 Maxim Sidorov. All rights reserved.
//

import UIKit

class LocationCell: UITableViewCell {
    
    var location: Location! {
        didSet {
            titleLabel.text = location.title
            subtitleLabel.text = location.subtitle
            locationImageView.image = location.image
        }
    }

    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.font = UIFont(name: "Helvetica-bold", size: 24)
        }
    }
    
    @IBOutlet weak var subtitleLabel: UILabel! {
        didSet {
            subtitleLabel.font = UIFont(name: "Helvetica-thin", size: 18)
            subtitleLabel.textColor = .lightGray
        }
    }
    
    @IBOutlet weak var locationImageView: UIImageView! {
        didSet {
            locationImageView.contentMode = .scaleAspectFill
        }
    }
    
    @IBOutlet weak var backView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        selectionStyle = .none
        setupBackView()
        setupLocationImageView()
    }
    
    private func setupBackView() {
        backView.cornerRadius = backView.frame.height * 0.15
        backView.addShadow()
    }
    
    private func setupLocationImageView() {
        locationImageView.cornerRadius = locationImageView.frame.height * 0.15
    }
    
}
