//
//  DownloadsViewController.swift
//  Netflix
//
//  Created by Sandra on 05/07/2023.
//

import UIKit

class DownloadsViewController: UIViewController {

    // MARK: - Properties
    var viewModel: DownloadsViewModelProtocol?
    private let downloadsTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(MovieTableViewCell.self, forCellReuseIdentifier: MovieTableViewCell.identifier)
        return tableView
    }()
    // MARK: - Lifecycle Method(s)
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Downloads"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        view.addSubview(downloadsTableView)
        setupTableViewDelegates()
        viewModel = DownloadsViewModel()
        viewModel?.getDownloadedMovies()
        NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: "downloads"), object: nil, queue: nil) {[weak self] _ in
            guard let self = self else { return }
            self.viewModel?.getDownloadedMovies()
            DispatchQueue.main.async {
                self.downloadsTableView.reloadData()
            }
        }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        downloadsTableView.frame = view.bounds
    }
    
    // MARK: - Function(s)
    private func setupTableViewDelegates() {
        downloadsTableView.delegate = self
        downloadsTableView.dataSource = self
    }
    
    func getMovie(for movie: String, movieModel: ResultModel) {
        guard let queryValue = movie.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        let parameters = [
            "q": queryValue,
            "key": AppKeys.youtubeKey
        ]
        APIClient.shared.getData(url: AppConstants.youtubeBaseURL, method: .get, parameters: parameters, responseClass: YoutubeSearchModel.self) {[weak self] response in
            guard let self = self else { return }
            switch response {
            case .success(let youtubeModel):
                guard let videoId = youtubeModel.items?[0].id else { return }
                DispatchQueue.main.async {
                    let vc = MoviePreviewViewController()
                    let moviePreviewModel = MoviePreviewModel(youtubeVideo: videoId , title: movie, description: movieModel.overview ?? "")
                    vc.configureView(with: moviePreviewModel)
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension DownloadsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.downloadedMoviesSubject.value.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.identifier, for: indexPath) as? MovieTableViewCell else { return UITableViewCell()}
        let movie = viewModel?.downloadedMoviesSubject.value[indexPath.row]
        cell.configureCell(with: ResultModel(adult: movie?.adult, backdropPath: movie?.backdropPath, id: Int(movie?.id ?? 0), title: movie?.title, originalLanguage: movie?.originalLanguage, originalTitle: movie?.originalTitle, overview: movie?.overview, posterPath: movie?.posterPath, mediaType: MediaType(rawValue: movie?.mediaType ?? ""), genreIDS: nil, popularity: movie?.popularity, releaseDate: movie?.releaseDate, video: movie?.video, voteAverage: movie?.voteAverage, voteCount: Int(movie?.voteCount ?? 0), name: movie?.name, originalName: movie?.originalName, firstAirDate: movie?.firstAirDate, originCountry: nil))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.bounds.height / 7.0
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            guard let movie = viewModel?.downloadedMoviesSubject.value[indexPath.row] else { return }
            viewModel?.deleteMovie(movie: movie)
            self.viewModel?.downloadedMoviesSubject.value.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        default:
            break
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let movie = viewModel?.downloadedMoviesSubject.value[indexPath.row]
        guard let movieTitle = movie?.originalTitle ?? movie?.originalName else { return }
        self.getMovie(for: movieTitle + " trailer", movieModel: ResultModel(adult: movie?.adult, backdropPath: movie?.backdropPath, id: Int(movie?.id ?? 0), title: movie?.title, originalLanguage: movie?.originalLanguage, originalTitle: movie?.originalTitle, overview: movie?.overview, posterPath: movie?.posterPath, mediaType: MediaType(rawValue: movie?.mediaType ?? ""), genreIDS: nil, popularity: movie?.popularity, releaseDate: movie?.releaseDate, video: movie?.video, voteAverage: movie?.voteAverage, voteCount: Int(movie?.voteCount ?? 0), name: movie?.name, originalName: movie?.originalName, firstAirDate: movie?.firstAirDate, originCountry: nil))
    }
}
