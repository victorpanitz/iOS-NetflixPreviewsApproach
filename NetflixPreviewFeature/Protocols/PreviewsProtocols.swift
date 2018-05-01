//
//  PreviewsProtocols.swift
//  NetflixPreviewFeature
//
//  Created by Victor Magalhaes on 29/04/2018.
//  Copyright © 2018 Victor Magalhaes. All rights reserved.
//

import Foundation
import UIKit

protocol PreviewItemTouchProtocol{
    func previewItemTouched(startPos: Int, cell: PreviewsCell, collectionOffsetX: CGFloat, itemFrame: CGRect)
}

protocol PreviewVideoEndedProtocol{
    func handlePreviewWhenVideoEnds(cell: PreviewVideoCell)
}
