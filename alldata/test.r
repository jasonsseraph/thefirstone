rm(list=ls(all=TRUE))
library(XML)
library(bitops)
library(RCurl)
library(httr)

orgURL = 'https://icook.tw/categories/7?page='
#orgURL = 'https://icook.tw/categories/7?page=2'

startPage = 2
endPage = 5
alldata = data.frame()
for( i in startPage:endPage)
{
  icookURL <- paste(orgURL, i, sep='')
  urlExists = url.exists(icookURL)
  
  if(urlExists)
  {
    html = getURL(icookURL, ssl.verifypeer = FALSE)
    xml = htmlParse(html, encoding ='utf-8')
    title = xpathSApply(xml, "//div[@class=\"media-body card-info\"]//a", xmlValue)
    path = xpathSApply(xml, "//div[@class=\"media-body card-info\"]/a//@href")
    like = xpathSApply(xml,"//li[@class=\"fav-count recipe-favorites\"]//span", xmlValue)
    tempdata = data.frame(title, path, like)
  }

  alldata = rbind(alldata, tempdata)
  
}
write.csv(alldata,"alldata.csv")

  