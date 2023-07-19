//
//  SearchViewController.swift
//  Netflix
//
//  Created by Sandra on 05/07/2023.
//

import UIKit

class SearchViewController: UIViewController {

    // MARK: - Constant(s)
    
    // MARK: - Properties
    private let topSearchTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(MovieTableViewCell.self, forCellReuseIdentifier: MovieTableViewCell.identifier)
        return tableView
    }()
    
    private let searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: SearchResultViewController())
        controller.searchBar.placeholder = "Search for a movie or a TV show..."
        controller.searchBar.searchBarStyle = .minimal
        return controller
    }()
    private var movies: [ResultModel] = []
    weak var searchBarTapDelegate: SearchBarTapDelegate?
    
    // MARK: - Lifecycle Method(s)
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Top Searches"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.tintColor = .white
        navigationItem.searchController = searchController
        view.addSubview(topSearchTableView)
        setupTopTableViewDelegates()
        getDiscoverMovies()
        searchController.searchResultsUpdater = self
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        topSearchTableView.frame = view.bounds
    }
    
    // MARK: - Function(s)
    private func setupTopTableViewDelegates() {
        topSearchTableView.delegate = self
        topSearchTableView.dataSource = self
    }
    private func reloadTableContent() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.topSearchTableView.reloadData()
        }
    }
    
    private func getDiscoverMovies() {
        let parameters = ["api_key" : AppKeys.APIKey]
        APIClient.shared.getData(url: AppConstants.baseURL + AppConstants.discover + AppConstants.movieKey, method: .get, parameters: parameters, responseClass: TrendingMoviesModel.self) { response in
            switch response {
            case .success(let data):
                self.movies = data.results
                self.reloadTableContent()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func searchBarTapped() {
            searchBarTapDelegate?.searchBarDidTap()
        }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.identifier, for: indexPath) as? MovieTableViewCell else { return  UITableViewCell()}
        cell.configureCell(with: movies[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.bounds.height / 7.0
    }
}

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar

        guard let query = searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty,
              query.trimmingCharacters(in: .whitespaces).count >= 3,
              let resultController = searchController.searchResultsController as? SearchResultViewController else { return }
        resultController.query = query
        resultController.searchBarDidTap()
    }
}
protocol SearchBarTapDelegate: AnyObject {
    func searchBarDidTap()
}
