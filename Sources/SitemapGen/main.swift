import SitemapGenCore

let sitemapGen = SitemapGen()

do {
  try sitemapGen.start()
} catch SitemapGen.SitemapGenError.failedToGetHTMLFiles {
  print("💥 failed to get HTML files.")
}

