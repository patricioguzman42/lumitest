import Foundation

enum ContentItemType: Decodable {
    case page
    case section
    case question(QuestionType)
}
