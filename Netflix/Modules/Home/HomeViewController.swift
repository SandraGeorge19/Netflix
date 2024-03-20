//
//  HomeViewController.swift
//  Netflix
//
//  Created by Sandra on 05/07/2023.
//

import UIKit

class HomeViewController: UIViewController {
    // MARK: - Properties
    private var viewModel: HomeViewModelProtocol = HomeViewModel()
    private var headerView:  HeroHeaderView?

    // MARK: - UIElement(s)
    let homeFeedTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(HomeCollectionViewTableViewCell.self, forCellReuseIdentifier: HomeCollectionViewTableViewCell.identifier)
        return tableView
    }()
    // MARK: - Lifecycle Method(s)
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
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeFeedTableView.frame = view.bounds
    }
    // MARK: - Function(s)
    private func configureHeaderMovie() {
        viewModel.trendingTvSubject.sink { [weak self] trendingTV in
            guard let self = self else { return }
            guard let randomMovie = trendingTV?.randomElement() else { return }
            self.headerView?.configureHeader(with: randomMovie)
        }.store(in: &viewModel.cancellables)
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

// MARK: - Extension(s)
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.sectionTitles[section]
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
        switch indexPath.section {
        case Sections.trendingMovies.rawValue:
            viewModel.trendingMoviesSubject.sink { trendingMovies in
                guard let results = trendingMovies else { return }
                cell.configureCell(with: results)
            }.store(in: &viewModel.cancellables)
        case Sections.trendingTV.rawValue:
            viewModel.trendingTvSubject.sink { trendingTV in
                guard let results = trendingTV else { return }
                cell.configureCell(with: results)
            }.store(in: &viewModel.cancellables)
        case Sections.popular.rawValue:
            viewModel.popularMoviesSubject.sink { popularMovies in
                guard let results = popularMovies else { return }
                cell.configureCell(with: results)
            }.store(in: &viewModel.cancellables)
        case Sections.upcomingMovies.rawValue:
            viewModel.upComingMoviesSubject.sink { upComingMovies in
                guard let results = upComingMovies else { return }
                cell.configureCell(with: results)
            }.store(in: &viewModel.cancellables)
        case Sections.topRated.rawValue:
            viewModel.topRatedMoviesSubject.sink { topRatedMovies in
                guard let results = topRatedMovies else { return }
                cell.configureCell(with: results)
            }.store(in: &viewModel.cancellables)
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
