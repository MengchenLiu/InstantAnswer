//
//  DetailBookmarkDelegate.swift
//  Go_Ask_a_Duck
//
//  Created by Mengchen Liu on 2/16/17.
//  Copyright © 2017 Mengchen Liu. All rights reserved.
//

import Foundation
protocol DetailBookmarkDelegate: class {
    func bookmarkPassedURL(url: String) -> Void
    func removeStar(url: String) -> Void
}

