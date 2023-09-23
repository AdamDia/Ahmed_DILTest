///First we need to create a file for networking logic
///File for Constants
///File for our DataModel

import UIKit

//MARK: -  Constants
enum Constants {
    static let cellIdentifier = "someCell" //Replace with a more convenient name
    static let validURL = "https://example.com/api" // Replace with the actual URL
    static let animationDuration = 0.5
    static let defaultHeight = CGFloat(150.0)
}

//MARK: -  ViewController
class SomeViewController: UIViewController {
    
    @IBOutlet weak var collectionViewTopConstraint: NSLayoutConstraint!
    @IBOutlet var detailViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var detailView: UIView!
    
    var detailVC: UIViewController?
    var dataArray: [DataModel]? // Replace 'DataModel' with your actual data model
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
    }
    
    // MARK: - Setup Methods
    
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: Constants.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: Constants.cellIdentifier)
    }
    
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Done", comment: ""), style: .plain, target: self, action: #selector(dismissController))
    }
    
    // MARK: - Action Methods
    
    @objc private func dismissController() {}
    
    @IBAction private func closeShowDetails() {
        toggleDetailsView(show: false)
    }
    
    @IBAction private func showDetail() {
        toggleDetailsView(show: true)
    }
    
    // MARK: - Helper Methods
    
    private func toggleDetailsView(show: Bool) {
        detailViewWidthConstraint.constant = show ? 100 : 0
        UIView.animate(withDuration: Constants.animationDuration, animations: { [weak self] in
            self?.view.layoutIfNeeded()
        }) { [weak self] (completed) in
            if show {
                self?.view.addSubview(self!.detailView)
            } else {
                self?.detailVC?.removeFromParent()
            }
        }
    }
    
    private func fetchData() {
          let dataFetcher = DataFetcher(urlString: Constants.validURL)
          dataFetcher.fetchData { [weak self] (result) in
              switch result {
              case .success(let dataArray):
                  self?.dataArray = dataArray
                  DispatchQueue.main.async {
                      self?.collectionView.reloadData()
                  }
              case .failure(let error):
                  // Handle the error (e.g., show an alert or log the error)
                  print("Error fetching data: \(error)")
              }
          }
      }
}

extension SomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // MARK: - UICollectionView Methods
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let widthMultiplier: CGFloat = DeviceHelpers.isIPhone() ? 0.9 : 0.2929
        return CGSize(width: view.frame.width * widthMultiplier, height: Constants.defaultHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        let frameWidth = (view.frame.width * 0.2929 * 3) + 84
        return DeviceHelpers.isIPhone() ? 24 : (view.frame.width - frameWidth) / 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArray?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.cellIdentifier, for: indexPath)
        // Configure the cell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        showDetail()
    }
}


//MARK: - utility 

struct DeviceHelpers {
    static func isIPhone() -> Bool {
        return UIDevice.current.userInterfaceIdiom == .phone
    }
}


//MARK: - DATA Model
struct DataModel {
    // Your model properties here
}


//MARK: - Network Layer

class DataFetcher {
    
    enum DataFetchError: Error {
        case invalidURL
        case dataParsingError
        case networkError(Error)
        case invalidResponse(Int?)
    }
    
    let urlString: String
    
    init(urlString: String) {
        self.urlString = urlString
    }
    
    func fetchData(completion: @escaping (Result<[DataModel], DataFetchError>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(.networkError(error)))
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
                completion(.failure(.invalidResponse(httpResponse.statusCode)))
                return
            }
            
            if let data = data, let parsedData = self.parse(data: data) {
                completion(.success(parsedData))
            } else {
                completion(.failure(.dataParsingError))
            }
        }
        
        task.resume()
    }
    
    private func parse(data: Data) -> [DataModel]? {
        // Replace this with your actual data parsing logic
        return nil
    }
}


