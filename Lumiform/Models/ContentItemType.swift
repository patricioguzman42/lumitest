//
//  ContentItemType.swift
//  Lumiform
//
//  Created by Patricio Guzman on 19/03/2025.
//

import Foundation

enum ContentItemType: Decodable {
    case page
    case section
    case question(QuestionType)
}
