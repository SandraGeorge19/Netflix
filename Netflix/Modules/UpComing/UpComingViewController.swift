//
//  UpComingViewController.swift
//  Netflix
//
//  Created by Sandra on 05/07/2023.
//

import UIKit

class UpComingViewController: UIViewController {

    // MARK: - Properties
    private let upcomingTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(MovieTableViewCell.self, forCellReuseIdentifier: MovieTableViewCell.identifier)
        return tableView
    }()
    private var movies: [ResultModel] = []
    
    // MARK: - Lifecycle Method(s)
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Coming Soon"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        view.addSubview(upcomingTableView)
        setupTableViewDelegates()
        getUpcomingMovies()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        upcomingTableView.frame = view.bounds
    }
    
    // MARK: - Function(s)
    private func setupTableViewDelegates() {
        upcomingTableView.delegate = self
        upcomingTableView.dataSource = self
    }
   
    func getUpcomingMovies() {
        let parameters = ["api_key" : AppKeys.APIKey]
        APIClient.shared.getData(url: AppConstants.baseURL + AppConstants.movie + AppConstants.upcomingMovies, method: .get, parameters: parameters, responseClass: UpcomingMoviesModel.self) { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .success(let data):
                self.movies = data.results
                print("upcoming \(self.movies)")
                DispatchQueue.main.async {
                    self.upcomingTableView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

// MARK: - Extension(s)

extension UpComingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.identifier, for: indexPath) as? MovieTableViewCell else { return UITableViewCell()}
        cell.configureCell(with: movies[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.bounds.height / 7.0
    }
}
