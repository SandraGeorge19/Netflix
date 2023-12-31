//
//  HeroHeaderView.swift
//  Netflix
//
//  Created by Sandra on 05/07/2023.
//

import UIKit
import Kingfisher

class HeroHeaderView: UIView {
    
    private let playButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.titlePadding = 10
        configuration.baseForegroundColor = .white
        let button = UIButton(configuration: configuration)
        button.layer.borderWidth = 1
        button.layer.borderColor = CGColor(red: 255, green: 255, blue: 255, alpha: 1)
        button.setTitle("Play", for: .normal)
        button.layer.cornerRadius = 8
        return button
    }()
    
    private let downloadButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.titlePadding = 10
        configuration.baseForegroundColor = .white
        let button = UIButton(configuration: configuration)
        button.layer.borderWidth = 1
        button.layer.borderColor = CGColor(red: 255, green: 255, blue: 255, alpha: 1)
        button.setTitle("Download", for: .normal)
        button.layer.cornerRadius = 8
        return button
    }()
    
    private let buttonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 40
        return stackView
    }()
    private let headerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "spiderMan")
        return imageView
    }()
    
    private func addGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.systemBackground.cgColor
        ]
        layer.addSublayer(gradientLayer)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(headerImageView)
        addGradient()
        addStackView()
    }
    private func addStackView() {
        addSubview(buttonsStackView)
        buttonsStackView.addArrangedSubview(playButton)
        buttonsStackView.addArrangedSubview(downloadButton)
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        headerImageView.frame = self.bounds
        buttonsStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 32).isActive = true
        buttonsStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -32).isActive = true
        buttonsStackView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 150).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureHeader(with model: ResultModel) {
        guard let url = URL(string: AppConstants.imgBaseURL + (model.posterPath ?? "")) else { return }
        headerImageView.kf.setImage(with: url)
    }
}
