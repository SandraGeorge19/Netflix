//
//  UpComingViewController.swift
//  Netflix
//
//  Created by Sandra on 05/07/2023.
//

import UIKit

class UpComingViewController: UIViewController {

    // MARK: - Properties
    private var viewModel: UpComingViewModelProtocol?
    private let upcomingTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(MovieTableViewCell.self, forCellReuseIdentifier: MovieTableViewCell.identifier)
        return tableView
    }()
    
    // MARK: - Lifecycle Method(s)
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Coming Soon"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        view.addSubview(upcomingTableView)
        setupTableViewDelegates()
        viewModel = UpComingViewModel()
        viewModel?.getUpComingMovies()
//        DispatchQueue.main.async {
//            self.upcomingTableView.reloadData()
//        }
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
}

// MARK: - Extension(s)

extension UpComingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.upComingMoviesSubject.value?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.identifier, for: indexPath) as? MovieTableViewCell else { return UITableViewCell()}
        guard let movie = viewModel?.upComingMoviesSubject.value?[indexPath.row] else { return UITableViewCell()}
        cell.configureCell(with: movie)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.bounds.height / 7.0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let movie = viewModel?.upComingMoviesSubject.value?[indexPath.row] else { return }
        guard let movieTitle = movie.originalTitle ?? movie.originalName else { return }
//        self.getMovie(for: movieTitle + " trailer", movieModel: movie)
    }
}
//
//extension UpComingViewController {
//    func getMovie(for movie: String, movieModel: ResultModel) {
//        guard let queryValue = movie.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
//        let parameters = [
//            "q": queryValue,
//            "key": AppKeys.youtubeKey
//        ]
//        APIClient.shared.getData(url: AppConstants.youtubeBaseURL, method: .get, parameters: parameters, responseClass: YoutubeSearchModel.self) {[weak self] response in
//            guard let self = self else { return }
//            switch response {
//            case .success(let youtubeModel):
//                guard let videoId = youtubeModel.items?[0].id else { return }
//                DispatchQueue.main.async {
//                    let vc = MoviePreviewViewController()
//                    let moviePreviewModel = MoviePreviewModel(youtubeVideo: videoId , title: movie, description: movieModel.overview ?? "")
//                    vc.configureView(with: moviePreviewModel)
//                    self.navigationController?.pushViewController(vc, animated: true)
//                }
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//        }
//    }
//}
