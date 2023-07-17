//
//  ItemCollectionViewCell.swift
//  Netflix
//
//  Created by Sandra on 17/07/2023.
//

import UIKit
import Kingfisher

class ItemCollectionViewCell: UICollectionViewCell {
    // MARK: - Constants
    static let identifier = "ItemCollectionViewCell"
    
    // MARK: - Properties
    private let poosterImgView: UIImageView = {
       let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        return imgView
    }()
    
    // MARK: - Lifecycle Method(s)
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(poosterImgView)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        poosterImgView.frame = contentView.bounds
    }
    
    // MARK: - Function(s)
    func configureCell(with imgURL: String) {
        guard let url = URL(string: imgURL) else { return }
        poosterImgView.kf.setImage(with: url)
    }
}
