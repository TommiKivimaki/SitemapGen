import XCTest
import class Foundation.Bundle
import Fichier

final class SitemapGenTests: XCTestCase {
  
  let fm = FileManager()
  
  var files: Fichier!
  var testDirectoryURL: URL!
  var testSubDirectoryURL: URL!
  var html1URL: URL!
  var html2URL: URL!
  var html3URL: URL!
  var htmlSubURL: URL!
  
  override func setUp() {
    files = Fichier()
    
    testDirectoryURL = productsDirectory.appendingPathComponent("testDirectory")
    try! files.createDirectory(at: testDirectoryURL)
    
    testSubDirectoryURL = testDirectoryURL.appendingPathComponent("testSubDirectory")
    try! files.createDirectory(at: testSubDirectoryURL)
    
    html1URL = testDirectoryURL.appendingPathComponent("html1").appendingPathExtension("html")
    html2URL = testDirectoryURL.appendingPathComponent("html2").appendingPathExtension("html")
    html3URL = testDirectoryURL.appendingPathComponent("html3").appendingPathExtension("html")
    _ = try! files.write(content: "", to: html1URL)
    _ = try! files.write(content: "", to: html2URL)
    _ = try! files.write(content: "", to: html3URL)
    
    htmlSubURL = testSubDirectoryURL.appendingPathComponent("htmlSub").appendingPathExtension("html")
    _ = try! files.write(content: "", to: htmlSubURL)
  }
  
  override func tearDown() {
    // Remove the test directory
    try! fm.removeItem(atPath: testDirectoryURL.path)
  }
  
  func testWithoutInputParameters() throws {
    guard #available(macOS 10.13, *) else { return }
    
    let binary = productsDirectory.appendingPathComponent("SitemapGen")
    
    let process = Process()
    process.executableURL = binary
    
    let pipe = Pipe()
    process.standardOutput = pipe
    
    try process.run()
    process.waitUntilExit()
    
    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    let output = String(data: data, encoding: .utf8)
    
    XCTAssertEqual(output, """
      SitemapGen v0.2.0 generates `sitemap.txt` for a website.

      USAGE: sitemapgen <hostname> <target>

      <hostname>      Hostname of the site
      <target>        Generates sitemap for this folder
      
      """)
  }
  
  
  func testTestDirectoryExists() {
    let result = try! files.readDirectory(from: testDirectoryURL)
    
    XCTAssertNotNil(result)
  }
  
  
  func testCreateSitemap() {
    guard #available(macOS 10.13, *) else {
      return
    }
    
    let binary = productsDirectory.appendingPathComponent("SitemapGen")
    
    let process = Process()
    process.executableURL = binary
    process.arguments = ["testDirectory", "foo.bar"]
    
    let pipe = Pipe()
    process.standardOutput = pipe
    
    try! process.run()
    process.waitUntilExit()
    
    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    let output = String(data: data, encoding: .utf8)!
    
    let expectedResult = """
                         https://foo.bar/html3.html
                         https://foo.bar/html2.html
                         https://foo.bar/html1.html
                         https://foo.bar/testSubDirectory/htmlSub.html

                         """
    XCTAssertEqual(output, expectedResult)
  }
  
  
  
  /// Returns path to the built products directory.
  var productsDirectory: URL {
    #if os(macOS)
    for bundle in Bundle.allBundles where bundle.bundlePath.hasSuffix(".xctest") {
      return bundle.bundleURL.deletingLastPathComponent()
    }
    fatalError("couldn't find the products directory")
    #else
    return Bundle.main.bundleURL
    #endif
  }
  
  static var allTests = [
    ("testExample", testWithoutInputParameters),
    ("testTestDirectoryExists", testTestDirectoryExists),
    ("testCreateSitemap", testCreateSitemap)
  ]
}
