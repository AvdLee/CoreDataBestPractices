//
//  ArticleListCell.swift
//  Core Data Best Practices
//
//  Created by Antoine van der Lee on 05/11/2020.
//

import Foundation
import UIKit
import Combine

final class ArticleListCell: UICollectionViewListCell {

    var article: Article? {
        didSet {
            updateCombineObservers()
        }
    }
    var cancellables: [AnyCancellable] = []

    override init(frame: CGRect) {
        super.init(frame: frame)
        tintColor = UIColor(named: "SwiftLee Orange")
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        cancellables.removeAll()
    }

    override func updateConfiguration(using state: UICellConfigurationState) {
        var content = defaultContentConfiguration().updated(for: state)
        content.text = article?.name

        let views = "\(article?.views ?? 0) views"
        content.secondaryText = (article?.categoryName ?? "Uncategorized") + " - " + views
        content.secondaryTextProperties.color = .secondaryLabel
        content.secondaryTextProperties.font = UIFont.preferredFont(forTextStyle: .subheadline)

        content.image = UIImage(systemName: "doc.plaintext")
        content.imageProperties.preferredSymbolConfiguration = .init(font: content.textProperties.font, scale: .large)

        contentConfiguration = content
    }
}
