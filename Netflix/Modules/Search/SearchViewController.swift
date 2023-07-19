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
    private var movies: [ResultModel] = []
    
    // MARK: - Lifecycle Method(s)
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Top Searches"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        view.addSubview(topSearchTableView)
        setupTopTableViewDelegates()
        getDiscoverMovies()
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
        APIClient.shared.getData(url: AppConstants.baseURL + AppConstants.discover + AppConstants.topSearch + AppKeys.APIKey, method: .get, responseClass: TrendingMoviesModel.self) { response in
            switch response {
            case .success(let data):
                self.movies = data.results
                self.reloadTableContent()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
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
