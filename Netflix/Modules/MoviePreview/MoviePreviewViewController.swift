//
//  MoviePreviewViewController.swift
//  Netflix
//
//  Created by Sandra on 19/07/2023.
//

import UIKit
import WebKit

class MoviePreviewViewController: UIViewController {

    // MARK: - Properties
    private let webView: WKWebView = {
        let web = WKWebView()
        web.translatesAutoresizingMaskIntoConstraints = false
        web.backgroundColor = .white
        return web
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 30, weight: .bold)
        label.text = "Movie Title"
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = .systemFont(ofSize: 16, weight: .light)
        label.numberOfLines = 0
        label.text = "Movie TitleMovie TitleMovie TitleMovie TitleMovie TitleMovie TitleMovie TitleMovie Title"
        return label
    }()
    
    private let downloadBtn: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        button.backgroundColor = .red
        button.layer.cornerRadius = 12
        button.setTitle("Download", for: .normal)
        button.layer.masksToBounds = true
        return button
    }()
    // MARK: - Lifecycle Method(s)
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubViews()
        configureConstraints()
    }
    
    // MARK: - Function(s)
    func configureView(with model: MoviePreviewModel) {
        titleLabel.text = model.title
        descriptionLabel.text = model.description
        guard let url = URL(string: AppConstants.youtubeVID + (model.youtubeVideo.videoID ?? "")) else { return }
        webView.load(URLRequest(url: url))
    }
}

// MARK: - Extension(s)
private extension MoviePreviewViewController {
    private func addSubViews() {
        view.addSubview(webView)
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(downloadBtn)
    }
    private func configureConstraints() {
        let webViewConstraints = [
            webView.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.35)
        ]
        let titleLblConstraints = [
            titleLabel.topAnchor.constraint(equalTo: webView.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ]
        let descLblConstraints = [
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 32),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ]
        let dowloadBtnConstraints = [
            downloadBtn.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 32),
            downloadBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            downloadBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            downloadBtn.heightAnchor.constraint(equalToConstant: 55)
        ]
        NSLayoutConstraint.activate(webViewConstraints)
        NSLayoutConstraint.activate(titleLblConstraints)
        NSLayoutConstraint.activate(descLblConstraints)
        NSLayoutConstraint.activate(dowloadBtnConstraints)
    }
}
