//
//  UICollectionView+Register.swift
//  WHBaseFramework
//
//  Created by 王红 on 2022/4/24.
//

import Foundation
import UIKit

//UITableView register cell / supplementaryView
public extension UICollectionView {
    func registerCell<T: UICollectionViewCell>(_: T.Type) {
        self.register(T.self, forCellWithReuseIdentifier: String(describing: T.self))
    }

    func dequeueCell<T: UICollectionViewCell>(_ indexPath: IndexPath) -> T {
        return self.dequeueReusableCell(withReuseIdentifier: String(describing: T.self), for: indexPath) as! T
    }

    func registerView<T: UIView>(_: T.Type, ofKind: String) {
        self.register(T.self, forSupplementaryViewOfKind: ofKind, withReuseIdentifier: String(describing: T.self))
    }

    func dequeueView<T: UIView>(ofKind: String, indexPath: IndexPath) -> T {
        return self.dequeueReusableSupplementaryView(ofKind: ofKind, withReuseIdentifier: String(describing: T.self), for: indexPath) as! T
    }
}
