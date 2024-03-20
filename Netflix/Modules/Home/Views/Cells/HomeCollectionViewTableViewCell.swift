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
    private var viewModel: HomeViewModelProtocol = HomeViewModel()
    private var movies: [ResultModel] = []
    weak var delegate: HomeCollectionViewTableViewCellDelegate?
    
    // MARK: - UIElement(s)
    private let itemCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 140, height: 200)
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ItemCollectionViewCell.self, forCellWithReuseIdentifier: ItemCollectionViewCell.identifier)
        return collectionView
    }()
    // MARK: - Init(s)
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        guard let movieTitle = movies[indexPath.row].originalTitle ?? movies[indexPath.row].originalName else { return }
        viewModel.getYoutubeResults(for: movieTitle + " trailer")
        viewModel.youtubeResultsSubject.sink {[weak self] movies in
            guard let self = self else { return }
            guard let movieID = movies?[0].id else { return }
            guard let movieDesc = self.movies[indexPath.row].overview else { return }
            let movieObj = MoviePreviewModel(youtubeVideo: movieID, title: movieTitle, description: movieDesc)
            delegate?.didTapCell(self, model: movieObj)
        }.store(in: &viewModel.cancellables)
    }
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
        let config = UIContextMenuConfiguration(
            identifier: nil,
            previewProvider: nil) { [weak self] _ in
                guard let self = self else { return UIMenu() }
                let downloadAction = UIAction(title: "Download", state: .off) { _ in
                    self.viewModel.downloadMovieWith(model: self.movies[indexPaths[0].row])
//                    self.downloadMovieAt(indexPath: indexPaths[0])
                }
                return UIMenu(children: [downloadAction])
            }
        return config
    }
}


protocol HomeCollectionViewTableViewCellDelegate: AnyObject {
    func didTapCell(_ cell: HomeCollectionViewTableViewCell, model: MoviePreviewModel)
}
