//
//  NewsCell.swift
//  NewsReaderCollectionView
//
//  Created by Patty Case on 4/3/20.
//  Copyright © 2020 Azure Horse Creations. All rights reserved.
//

import UIKit

protocol ReusableView: AnyObject {
    static var identifier: String { get }
}

final class NewsCell: UICollectionViewCell {

    private enum Constants {
        // MARK: contentView layout constants
        static let contentViewCornerRadius: CGFloat = 4.0

        // MARK: image layout constants
        static let imageHeight: CGFloat = 240.0

        // MARK: Generic layout constants
        static let verticalSpacing: CGFloat = 8.0
        static let horizontalPadding: CGFloat = 16.0
        static let verticalPadding: CGFloat = 8.0
    }

    private let image: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    let title: UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    let summary: UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupViews()
        setupLayouts()
    }
    
//    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
//
//        setNeedsLayout()
//        layoutIfNeeded()
//        let size = contentView.systemLayoutSizeFitting(layoutAttributes.size)
//        var frame = layoutAttributes.frame
//        frame.size.height = ceil(size.height)
//        layoutAttributes.frame = frame
//        return layoutAttributes
//    }

    private func setupViews() {
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = Constants.contentViewCornerRadius
        contentView.backgroundColor = .white

        contentView.addSubview(image)
        contentView.addSubview(title)
//        contentView.addSubview(summary)
    }

    private func setupLayouts() {
        image.translatesAutoresizingMaskIntoConstraints = false
        title.translatesAutoresizingMaskIntoConstraints = false
//        summary.translatesAutoresizingMaskIntoConstraints = false

        // Layout constraints for `image`
        NSLayoutConstraint.activate([
            image.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            image.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            image.topAnchor.constraint(equalTo: contentView.topAnchor),
            image.heightAnchor.constraint(equalToConstant: Constants.imageHeight)
        ])

        // Layout constraints for `title`
        NSLayoutConstraint.activate([
            title.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.horizontalPadding),
            title.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.horizontalPadding),
            title.topAnchor.constraint(equalTo: image.bottomAnchor, constant: Constants.verticalPadding)
        ])

        // Layout constraints for `summary`
//        NSLayoutConstraint.activate([
//            summary.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.horizontalPadding),
//            summary.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.horizontalPadding),
//            summary.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 5.0)
//        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup(with news: News) {
        image.image = news.image
        title.text = news.title
//        summary.text = news.summary
    }
}

extension NewsCell: ReusableView {
    static var identifier: String {
        return String(describing: self)
    }
}
