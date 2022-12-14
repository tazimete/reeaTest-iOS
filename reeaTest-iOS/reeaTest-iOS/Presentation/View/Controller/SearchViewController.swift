//
//  ViewController.swift
//  setScheduleTest
//
//  Created by JMC on 29/10/21.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class SearchViewController: BaseViewController {
    // MARK: Non UI Proeprties
    public weak var coordinator: SearchCoordinator?
    public var searchViewModel: AbstractSearchViewModel!
    private let disposeBag = DisposeBag()
    private let searchTrigger = PublishSubject<SearchViewModel.SearchInputModel>()
    
    // MARK: UI Proeprties
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.separatorInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
        
        //cell registration
        tableView.register(SearchItemCell.self, forCellReuseIdentifier: SearchItemCellConfig.reuseId)
        tableView.register(SearchShimmerCell.self, forCellReuseIdentifier: ShimmerItemCellConfig.reuseId)
        
        tableView.rx.setDelegate(self).disposed(by: self.disposeBag)
        return tableView
    }()
    
    private let lblNoData: UILabel = {
        let label = UILabel()
        label.text = "No data to show, Plz search by tapping on search button in top bar."
        label.textColor = .darkGray
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.isSkeletonable = false
        label.skeletonLineSpacing = 10
        label.multilineSpacing = 10
        return label
    }()

    // MARK: Constructors
    init(viewModel: AbstractSearchViewModel) {
        super.init(viewModel: viewModel)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }

    // MARK: Overrriden Methods
    override func initView() {
        super.initView()
        //setup tableview
        view.addSubview(tableView)
        view.addSubview(lblNoData)
        
        //set anchor
        tableView.snp.makeConstraints { (make) -> Void in
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(view.snp.bottom)
        }
        
        lblNoData.snp.makeConstraints { (make) -> Void in
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(view.snp.bottom)
        }
        
        //table view
        onTapTableviewCell()
    }
    
    //when theme change, we can also define dark mode color option in color asse
    override public func applyDarkTheme() {
        navigationController?.navigationBar.backgroundColor = .lightGray
        tableView.backgroundColor = .black
        self.navigationItem.rightBarButtonItem?.tintColor = .lightGray
        tableView.reloadData()
    }
    
    override public func applyNormalTheme() {
        navigationController?.navigationBar.backgroundColor = .white
        tableView.backgroundColor = .white
        self.navigationItem.rightBarButtonItem?.tintColor = .black
        tableView.reloadData()
    }
    
    override func initNavigationBar() {
        self.navigationItem.title = "Search"
        let btnSearch = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(didTapSearchButton))
        btnSearch.tintColor = .gray
        self.navigationItem.rightBarButtonItem = btnSearch
    }
    
    // MARK: Pagination 
    override func hasMoreData() -> Bool {
        return searchViewModel.currentPage <= searchViewModel.totalPage
    }
    
    override func loadMoreData() {
        searchMovie(name: "the", year: 2000)
    }
    
    override func getLastVisibleItem() -> IndexPath {
        return tableView.indexPathsForVisibleRows?.last ?? IndexPath(row: 0, section: 0)
    }
    
    override func getTotalDataCount() -> Int {
        return searchViewModel.totalDataCount
    }
    
    override func getPaginationOffset() -> Int {
        return 5
    }
    
    override func bindViewModel() {
        searchViewModel = (viewModel as! AbstractSearchViewModel)
        let searchInput = SearchViewModel.SearchInput(searchItemListTrigger: searchTrigger)
        let searchOutput = searchViewModel.getSearchOutput(input: searchInput)
        
        //populate table view
        searchOutput.searchItems.observe(on: MainScheduler.instance)
            .bind(to: tableView.rx.items) { [weak self] tableView, row, model in
                guard let weakSelf = self else {
                    return UITableViewCell()
                }
                
                return weakSelf.populateTableViewCell(viewModel: (model.asDomain?.asCellViewModel)!, indexPath: IndexPath(row: row, section: 0), tableView: tableView)
            }.disposed(by: disposeBag)
        
        // detect error
        searchOutput.errorTracker.observe(on: MainScheduler.instance)
            .subscribe(onNext: {
                [weak self] error in
                
                guard let weakSelf = self, let error = error else {
                    return
                }
            
            print("\(String(describing: weakSelf.TAG)) -- bindViewModel() -- error  -- code = \(error.errorCode), message = \(error.errorMessage)")
        }).disposed(by: disposeBag)
    }
    
    //populate table view cell
    private func populateTableViewCell(viewModel: AbstractCellViewModel, indexPath: IndexPath, tableView: UITableView) -> UITableViewCell {
        var item: CellConfigurator = SearchItemCellConfig.init(item: viewModel)
        
        // check actual data exists or not, to hide shimmer cell
        if viewModel.id == nil {
            item = ShimmerItemCellConfig.init(item: viewModel)
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: type(of: item).reuseId, for: indexPath)
        item.configure(cell: cell)
        
        return cell
    }
    
    // MARK: Actions
    private func onTapTableviewCell() {
        Observable
            .zip(tableView.rx.itemSelected, tableView.rx.modelSelected(Movie.self))
            .bind { [weak self] indexPath, model in
                guard let weakSelf = self else {
                    return
                }
                
                weakSelf.tableView.deselectRow(at: indexPath, animated: true)
                print("\(weakSelf.TAG) -- onTapTableviewCell() -- Selected " + (model.originalTitle ?? "") + " at \(indexPath)")
                
                //navigate to profile view controller
                weakSelf.navigateToDetailsController(with: model)
            }
            .disposed(by: disposeBag)
    }
    
     func searchMovie(name: String, year: Int) {
        hideNoDataMessageView()
        searchTrigger.onNext(SearchViewModel.SearchInputModel(query: name, year: year, page: searchViewModel.currentPage))
    }
    
    private func hideNoDataMessageView() {
        lblNoData.isHidden = true
    }
    
    private func navigateToDetailsController(with movie: Movie) {
        coordinator?.showDetailsController(movie: movie)
    }
    
    @objc func didTapSearchButton(sender : AnyObject){
        showSearchDialog()
    }
    
    private func showSearchDialog() {
        let alertController = UIAlertController(title: "Search movie", message: "Enter movie name. Ex- The \n Enter releasing year. Ex- 2000", preferredStyle: UIAlertController.Style.alert)
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Movie name"
        }
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Releasing year"
        }
        
        let saveAction = UIAlertAction(title: "Search", style: UIAlertAction.Style.default, handler: { [weak self] alert -> Void in
            let name = (alertController.textFields?[0])?.text ?? ""
            let year = (alertController.textFields?[1])?.text ?? ""
            
            if !name.isEmpty && !year.isEmpty {
                self?.searchMovie(name: name, year: Int(year) ?? 00)
            }
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: {
            (action : UIAlertAction!) -> Void in })
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(120).adaptiveValue()
    }
}
