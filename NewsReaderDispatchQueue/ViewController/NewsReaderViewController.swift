//
//  NewsReaderViewController.swift
//  NewsReaderDispatchQueue
//
//  Created by Patty Case on 4/15/20.
//  Copyright © 2020 Azure Horse Creations. All rights reserved.
//

import UIKit

class NewsReaderViewController: UIViewController {

    var newsList: [News] = []
    var newsImages: [UIImage] = []
    private let newsReaderModelController: NewsReaderModelController
    private let spinnerViewController: SpinnerViewController

    private let collectionView: UICollectionView = {
        let viewLayout = UICollectionViewFlowLayout()
        viewLayout.itemSize = UICollectionViewFlowLayout.automaticSize
//        viewLayout.estimatedItemSize = CGSize(width: 175, height: 150)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: viewLayout)
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    private enum LayoutConstant {
        static let spacing: CGFloat = 16.0
        static let itemHeight: CGFloat = 400.0
    }
    
    required init(coder aDecoder: NSCoder) {
        self.newsReaderModelController = NewsReaderModelController()
        self.spinnerViewController = SpinnerViewController()
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupLayouts()
        
        startSpinner(child: spinnerViewController)
        
        // Call newsReaderModelController to get the news headlines
        newsReaderModelController.downloadNews(apiUrl: Constants.Urls.CNN_API_URL) { (response) in
            
            self.stopSpinner(child: self.spinnerViewController)
            
            if let responseArray = response as? [News] {
                for news in responseArray {
                    self.newsList.append(news)
                }
            }
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(collectionView)
        
        collectionView.dataSource = self
//        collectionView.prefetchDataSource = self
        collectionView.delegate = self
        collectionView.register(NewsCell.self, forCellWithReuseIdentifier: NewsCell.identifier)
    }

    private func setupLayouts() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        // Layout constraints for `collectionView`
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }
    
    // Start spinner view controller
    func startSpinner(child: SpinnerViewController) {
        addChild(child)
        child.view.frame = view.frame
        view.addSubview(child.view)
        child.didMove(toParent: self)
    }
    
    // Stop spinner view controller
    func stopSpinner(child: SpinnerViewController) {
        DispatchQueue.main.async() {
            child.willMove(toParent: nil)
            child.view.removeFromSuperview()
            child.removeFromParent()
        }
    }
}

extension NewsReaderViewController: UICollectionViewDataSource {
    
    // Go to url of selected item
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NewsReaderDetailViewController") as! NewsReaderDetailViewController
        vc.url = newsList[indexPath.row].url
        let navigationController = UINavigationController(rootViewController: vc)
        self.present(navigationController, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return newsList.count
    }
    
    // Render cell with news information and image
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewsCell.identifier, for: indexPath) as! NewsCell

        let currentNews = newsList[indexPath.row]
        
        newsReaderModelController.downloadNews(apiUrl: Constants.Urls.CNN_API_URL) { (response) in
            if let responseArray = response as? [News] {
                for news in responseArray {
                    self.newsList.append(news)
                }
            }
        }
        
        newsReaderModelController.downloadImage(imageUrl: currentNews.image_url) { (response) in
            if let image = response as? UIImage {
                currentNews.image = image
            } else {
                currentNews.image = UIImage(named: "placeholder.png") 
            }
            cell.setup(with: currentNews)
        }
        cell.contentView.backgroundColor = UIColor(name: "lightsteelblue")
        return cell
    }
}

extension NewsReaderViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let width = itemWidth(for: view.frame.width, spacing: LayoutConstant.spacing)

        return CGSize(width: width, height: LayoutConstant.itemHeight)
    }

    func itemWidth(for width: CGFloat, spacing: CGFloat) -> CGFloat {
        let itemsInRow: CGFloat = 1

        let totalSpacing: CGFloat = 2 * spacing + (itemsInRow - 1) * spacing
        let finalWidth = (width - totalSpacing) / itemsInRow

        return floor(finalWidth)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: LayoutConstant.spacing, left: LayoutConstant.spacing, bottom: LayoutConstant.spacing, right: LayoutConstant.spacing)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return LayoutConstant.spacing
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return LayoutConstant.spacing
    }
}
