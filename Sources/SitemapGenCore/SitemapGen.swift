//
//  SitemapGen.swift
//  
//
//  Created by Tommi Kivimäki on 19.12.2019.
//

import Foundation
import Fichier

public final class SitemapGen {
  
  let commandlineArguments: [String]
  let files = Fichier()
  
  public init(arguments: [String] = CommandLine.arguments) {
    self.commandlineArguments = arguments
  }
  
  
  /// Runs the sitemap generation
  public func start() {
    guard commandlineArguments.count == 2 else {
      usage()
      return
    }
    
    let hostname = commandlineArguments[1]
    let urls = getHTMLFiles()
    let sitemap = makeMap(hostname, using: urls)
   
    let sitemapURL = files.getCurrentDirectory()
      .appendingPathComponent("sitemap")
      .appendingPathExtension("txt")
    
    do {
      _ = try files.write(content: sitemap, to: sitemapURL)
      print(sitemap)
    } catch {
      print("Failed to write sitemap")
    }
  }
  
  
  /// Gets all the HTML files from the current directory
  func getHTMLFiles() -> [URL] {
    let currentDirectory = files.getCurrentDirectory()
    do {
      let urls = try files.getAllFiles(from: [currentDirectory])
      return urls.filter { $0.pathExtension == "html" }
    } catch {
      print("Failed to get all files")
    }
    
    return []
  }
  
  /// Creates a sitemap by replacing the local filepaths with a hostname and a scheme
  /// - Parameters:
  ///   - hostname: Hostname for the site
  ///   - urls: urls to be included in the sitemap
  func makeMap(_ hostname: String, using urls: [URL]) -> String {
    var map = ""
    let currentDirectory = files.getCurrentDirectory()
    let basePath = "https://".appending(hostname)
    urls.forEach {
      let serverPath = $0.path.replacingOccurrences(of: currentDirectory.path, with: basePath)
      map.append(serverPath)
      map.append("\n")
    }
    // Drop the last newline and return
    return String(map.dropLast())
  }
  
  /// Prints out usage instructions
  private func usage() {
    print("""
          SitemapGen v0.1.0 generates sitemap.txt for a website.
          """)
  }
}
