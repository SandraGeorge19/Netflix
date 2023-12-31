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
    private var movieID: ID?
    weak var delegate: HomeCollectionViewTableViewCellDelegate?
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
    
    private func getYoutubeResult(for movie: String) {
        guard let queryValue = movie.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        let parameters = [
            "q": queryValue,
            "key": AppKeys.youtubeKey
        ]
        APIClient.shared.getData(url: AppConstants.youtubeBaseURL, method: .get, parameters: parameters, responseClass: YoutubeSearchModel.self) { response in
            switch response {
            case .success(let data):
                guard let movie = data.items?[0] else { return }
                self.movieID = movie.id
            case .failure(let error):
                print(error.localizedDescription)
            }
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
        self.getYoutubeResult(for: movieTitle + " trailer")
        guard let movieID = movieID else { return }
        guard let movieDesc = movies[indexPath.row].overview else { return }
        let movieObj = MoviePreviewModel(youtubeVideo: movieID, title: movieTitle, description: movieDesc)
        delegate?.didTapCell(self, model: movieObj)
    }
    
}


protocol HomeCollectionViewTableViewCellDelegate: AnyObject {
    func didTapCell(_ cell: HomeCollectionViewTableViewCell, model: MoviePreviewModel)
}
