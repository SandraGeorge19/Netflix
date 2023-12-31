//
//  HomeViewController.swift
//  Netflix
//
//  Created by Sandra on 05/07/2023.
//

import UIKit

class HomeViewController: UIViewController {
    
    private var headerView:  HeroHeaderView?
    private var randomMovie: ResultModel?
    let sectionTitles: [String] = ["Trending Movies", "Trending TV", "Popular","Upcoming Movies", "Top Rated"]

    let homeFeedTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(HomeCollectionViewTableViewCell.self, forCellReuseIdentifier: HomeCollectionViewTableViewCell.identifier)
        return tableView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        view.addSubview(homeFeedTableView)
        
        homeFeedTableView.delegate = self
        homeFeedTableView.dataSource = self
        
        configureNavBar()
        headerView = HeroHeaderView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 450))
        homeFeedTableView.tableHeaderView = headerView
        configureHeaderMovie()
    }
    
    private func configureHeaderMovie() {
        let parameters = ["api_key" : AppKeys.APIKey]
        APIClient.shared.getData(url: AppConstants.baseURL + AppConstants.trending + AppConstants.trendingTv, method: .get, parameters: parameters,responseClass: TrendingMoviesModel.self) { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .success(let data):
                self.randomMovie = data.results.randomElement()
                guard let randomMovie = self.randomMovie else { return }
                self.headerView?.configureHeader(with: randomMovie)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeFeedTableView.frame = view.bounds
    }
    
    private func configureNavBar() {
        var netflixLogo = UIImage(named: "pngwing.com")?.resizeImageTo(size: CGSize(width: 44, height: 44))
        netflixLogo = netflixLogo?.withRenderingMode(.alwaysOriginal)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: netflixLogo, style: .done, target: self, action: nil
        )
        self.navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: self, action: nil),
            UIBarButtonItem(image: UIImage(systemName: "play.rectangle"), style: .done, target: self, action: nil)
        ]
        navigationController?.navigationBar.tintColor = .white
    }

}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        header.textLabel?.frame = CGRect(x: header.bounds.origin.x + 20, y: header.bounds.origin.y, width: 100, height: header.bounds.height)
        header.textLabel?.textColor = .white
        header.textLabel?.text = header.textLabel?.text?.capitalized
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeCollectionViewTableViewCell.identifier, for: indexPath) as? HomeCollectionViewTableViewCell else { return UITableViewCell()}
        cell.delegate = self
        configureHomeTableViewCells(cell: cell, indexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defaultOffset = view.safeAreaInsets.top
        let offset = scrollView.contentOffset.y + defaultOffset
        
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
    }
}

// MARK: - Extension for configuring table view cell
private extension HomeViewController {
    func configureHomeTableViewCells(cell: HomeCollectionViewTableViewCell, indexPath: IndexPath) {
        let parameters = ["api_key" : AppKeys.APIKey]
        switch indexPath.section {
        case Sections.trendingMovies.rawValue:
            APIClient.shared.getData(url: AppConstants.baseURL + AppConstants.trending + AppConstants.trendingMovie, method: .get, parameters: parameters,responseClass: TrendingMoviesModel.self) { response in
                switch response {
                case .success(let data):
                    cell.configureCell(with: data.results)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        case Sections.trendingTV.rawValue:
            APIClient.shared.getData(url: AppConstants.baseURL + AppConstants.trending + AppConstants.trendingTv, method: .get, parameters: parameters,responseClass: TrendingMoviesModel.self) { response in
                switch response {
                case .success(let data):
                    cell.configureCell(with: data.results)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        case Sections.popular.rawValue:
            APIClient.shared.getData(url: AppConstants.baseURL + AppConstants.movie + AppConstants.popularMovies, method: .get, parameters: parameters, responseClass: TrendingMoviesModel.self) { response in
                switch response {
                case .success(let data):
                    cell.configureCell(with: data.results)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        case Sections.upcomingMovies.rawValue:
            APIClient.shared.getData(url: AppConstants.baseURL + AppConstants.movie + AppConstants.upcomingMovies, method: .get, parameters: parameters, responseClass: UpcomingMoviesModel.self) { response in
                switch response {
                case .success(let data):
                    cell.configureCell(with: data.results)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        case Sections.topRated.rawValue:
            APIClient.shared.getData(url: AppConstants.baseURL + AppConstants.movie + AppConstants.topRatedMovies, method: .get, parameters: parameters, responseClass: TrendingMoviesModel.self) { response in
                switch response {
                case .success(let data):
                    cell.configureCell(with: data.results)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        default:
            print("Noting for configuring HomeTableViewCell")
        }
    }
}
extension HomeViewController: HomeCollectionViewTableViewCellDelegate {
    func didTapCell(_ cell: HomeCollectionViewTableViewCell, model: MoviePreviewModel) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let vc = MoviePreviewViewController()
            vc.configureView(with: model)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
}
