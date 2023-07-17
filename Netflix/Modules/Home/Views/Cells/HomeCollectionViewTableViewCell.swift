//
//  HomeCollectionViewTableViewCell.swift
//  Netflix
//
//  Created by Sandra on 05/07/2023.
//

import UIKit

class HomeCollectionViewTableViewCell: UITableViewCell {

    // MARK: - Constant(s)
    static let identifier = "HomeCollectionViewTableViewCell"
    
    // MARK: - Properties
    private let itemCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 140, height: 200)
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ItemCollectionViewCell.self, forCellWithReuseIdentifier: ItemCollectionViewCell.identifier)
        return collectionView
    }()
    
    private var movies: [ResultModel] = []
    // MARK: - Init(s)
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .systemPink
        contentView.addSubview(itemCollectionView)
        itemCollectionView.delegate = self
        itemCollectionView.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Lifecycle Method(s)
    override func layoutSubviews() {
        super.layoutSubviews()
        itemCollectionView.frame = contentView.bounds
    }
    // MARK: - Function(s)
    func configureCell(with movies: [ResultModel]) {
        self.movies = movies
        reloadCollectionView()
    }
    
    private func reloadCollectionView() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.itemCollectionView.reloadData()
        }
    }
}

extension HomeCollectionViewTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemCollectionViewCell.identifier, for: indexPath) as? ItemCollectionViewCell else { return UICollectionViewCell() }
        cell.configureCell(with: AppConstants.imgBaseURL + (movies[indexPath.row].posterPath ?? ""))
        return cell
    }
    
    
}
