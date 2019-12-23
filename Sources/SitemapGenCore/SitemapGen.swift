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
  public func start() throws {
    guard commandlineArguments.count == 3 else {
      usage()
      return
    }
    
    let hostname = commandlineArguments[1]
    let path = commandlineArguments[2]
    let urls = try getHTMLFiles(path)
    let sitemap = makeMap(hostname, using: urls, originPath: path)
   
    let sitemapURL = files.getCurrentDirectory()
      .appendingPathComponent(path)
      .appendingPathComponent("sitemap")
      .appendingPathExtension("txt")
    
    do {
      _ = try files.write(content: sitemap, to: sitemapURL)
      print(sitemap)
      print("sitemap.txt written to `\(path)`")
    } catch {
      print("Failed to write sitemap")
    }
  }
  
  
  /// Gets all the HTML files from the current directory
  func getHTMLFiles(_ fromPath: String) throws -> [URL] {
    let path = files.getCurrentDirectory().appendingPathComponent(fromPath)
    do {
      let urls = try files.getAllFiles(from: [path])
      return urls.filter { $0.pathExtension == "html" }
    } catch {
      throw SitemapGenError.failedToGetHTMLFiles
    }

  }
  
  
  /// Creates a sitemap by replacing the local filepaths with a hostname and a scheme
  /// - Parameters:
  ///   - hostname: Hostname for the site
  ///   - urls: urls to be included in the sitemap
  func makeMap(_ hostname: String, using urls: [URL], originPath: String) -> String {
    var map = ""
    let fromURL = files.getCurrentDirectory().appendingPathComponent(originPath)
    let basePath = "https://".appending(hostname)
    urls.forEach {
      let serverPath = $0.path.replacingOccurrences(of: fromURL.path, with: basePath)
      map.append(serverPath)
      map.append("\n")
    }
    // Drop the last newline and return
    return String(map.dropLast())
  }
  
  
  /// Prints out usage instructions
  private func usage() {
    print("""
          SitemapGen v0.4.0 generates `sitemap.txt` for a website.

          USAGE: sitemapgen <hostname> <target>

          <hostname>      Hostname of the site
          <target>        Generates sitemap for this folder
          """)
  }
}
