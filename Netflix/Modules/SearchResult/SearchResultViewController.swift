//
//  SearchResultViewController.swift
//  Netflix
//
//  Created by Sandra on 19/07/2023.
//

import UIKit

protocol SearchResultViewControllerDelegate: AnyObject {
    func didTapOnItemOfSearch(model: MoviePreviewModel)
}

class SearchResultViewController: UIViewController {

    // MARK: - Delegates
    weak var delegate: SearchResultViewControllerDelegate?
    // MARK: - Properties
    private let searchResultCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 3 - 10, height: 200)
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ItemCollectionViewCell.self, forCellWithReuseIdentifier: ItemCollectionViewCell.identifier)
        return collectionView
    }()
    private var movies: [ResultModel] = []
    var query: String?
    
    // MARK: - Lifecycle Method(s)
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(searchResultCollectionView)
        setCollectionViewDelegates()
        SearchViewController().searchBarTapDelegate = self
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchResultCollectionView.frame = view.bounds
    }
    // MARK: - Function(s)
    private func setCollectionViewDelegates() {
        searchResultCollectionView.delegate = self
        searchResultCollectionView.dataSource = self
    }
    private func reloadData() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.searchResultCollectionView.reloadData()
        }
    }
    private func getSearchResults(for searchText: String) {
        guard let queryValue = searchText.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        let parameters = [
            "api_key": AppKeys.APIKey,
            "query": queryValue
        ]
        APIClient.shared.getData(url: AppConstants.baseURL + AppConstants.search + AppConstants.movieKey, method: .get, parameters: parameters, responseClass: TrendingMoviesModel.self) { response in
            switch response {
            case .success(let data):
                self.movies = data.results
                self.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

// MARK: - Extension(s)
extension SearchResultViewController: UICollectionViewDelegate, UICollectionViewDataSource {
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
        let movie = movies[indexPath.row]
        guard let movieTitle = movie.originalTitle ?? movie.originalName else { return }
        self.getMovie(for: movieTitle, movieModel: movie)
    }
}

extension SearchResultViewController: SearchBarTapDelegate {
    func searchBarDidTap() {
        guard let query = query else { return }
        getSearchResults(for: query)
    }
    func getMovie(for movieTitle: String, movieModel: ResultModel) {
        guard let queryValue = movieTitle.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        let parameters = [
            "q": queryValue,
            "key": AppKeys.youtubeKey
        ]
        APIClient.shared.getData(url: AppConstants.youtubeBaseURL, method: .get, parameters: parameters, responseClass: YoutubeSearchModel.self) {[weak self] response in
            guard let self = self else { return }
            switch response {
            case .success(let youtubeModel):
                guard let videoId = youtubeModel.items?[0].id else { return }
                self.delegate?.didTapOnItemOfSearch(model: MoviePreviewModel(youtubeVideo: videoId, title: movieTitle, description: movieModel.overview ?? ""))
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
