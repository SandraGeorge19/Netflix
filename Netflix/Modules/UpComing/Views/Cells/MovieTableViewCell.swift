//
//  UpcomingTableViewCell.swift
//  Netflix
//
//  Created by Sandra on 17/07/2023.
//

import UIKit

class MovieTableViewCell: UITableViewCell {

    // MARK: - Constant(s)
    static let identifier = "MovieTableViewCell"
    // MARK: - Properties
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let poosterImgView: UIImageView = {
       let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }()
    
    private let playButton: UIButton = {
        let button = UIButton()
        let img = UIImage(systemName: "play.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
        button.tintColor = .white
        button.setImage(img, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Init(s)
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(titleLabel)
        contentView.addSubview(poosterImgView)
        contentView.addSubview(playButton)
        applyConstraints()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError()
    }
    // MARK: - Lifcycle Method(s)
    
    // MARK: - Functions
    private func applyConstraints() {
        let poosterImgViewConstraints = [
            poosterImgView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            poosterImgView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            poosterImgView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            poosterImgView.widthAnchor.constraint(equalToConstant: 100)
        ]
        let titleLabelConstraints = [
            titleLabel.leadingAnchor.constraint(equalTo: poosterImgView.trailingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ]
        let playButtonConstraints = [
            playButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            playButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            playButton.heightAnchor.constraint(equalToConstant: 50),
            playButton.widthAnchor.constraint(equalToConstant: 50),
            playButton.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 16)
        ]
        NSLayoutConstraint.activate(poosterImgViewConstraints)
        NSLayoutConstraint.activate(titleLabelConstraints)
        NSLayoutConstraint.activate(playButtonConstraints)
    }
    
    func configureCell(with model: ResultModel) {
        guard let url = URL(string: AppConstants.imgBaseURL + (model.posterPath ?? "")) else { return }
        poosterImgView.kf.setImage(with: url)
        titleLabel.text = model.originalTitle
    }
}
