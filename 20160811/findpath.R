rm(list=ls(all=TRUE))
library(XML)
library(bitops)
library(RCurl)
library(httr)

orgURL = 'https://www.ptt.cc/bbs/cvs/index'
#orgURL = 'https://www.ptt.cc/bbs/cvs/index.html'

startPage = 1
endPage = 5
alldata = data.frame()
for( i in startPage:endPage)
{
  pttURL <- paste(orgURL, i, '.html', sep='')
  urlExists = url.exists(pttURL)
  
  if(urlExists)
  {
    html = getURL(pttURL, ssl.verifypeer = FALSE)
    xml = htmlParse(html, encoding ='utf-8')
    title = xpathSApply(xml, "//div[@class='title']/a//text()", xmlValue)
    author = xpathSApply(xml, "//div[@class='author']", xmlValue)
    path = xpathSApply(xml, "//div[@class='title']/a//@href")
    date = xpathSApply(xml, "//div[@class='date']", xmlValue)
    response = xpathSApply(xml, "//div[@class='nrec']", xmlValue)
    tempdata = data.frame(title, author, path, date, response)
  }
  alldata = rbind(alldata, tempdata)
}

write.csv(alldata,"alldata.csv")