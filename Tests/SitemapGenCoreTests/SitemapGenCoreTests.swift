import XCTest
import Foundation.Bundle
@testable import SitemapGenCore

final class SitemapGenCore: XCTestCase {
  
  let files: Fichier!
  let sitemapGen: SitemapGenCore!
  
  override func setUp() {
    files = Fichier()
    sitemapGen = SitemapGenCore()
  }
  
  override tearDown() {
    files = nil
    sitemapGen = nil
  }
  
  func testExample() {

  }
  
  static var allTests = [
    ("testExample", testExample),
  ]
}
