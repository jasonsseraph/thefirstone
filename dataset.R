rm(list=ls(all=TRUE))
library(XML)
library(bitops)
library(RCurl)
library(NLP)
library(httr)

Sys.setlocale("LC_ALL", "cht")

alldata = read.csv('alldata.csv')
orgURL = 'https://icook.tw'
for( i in 1:length(alldata$X))
{
  icookURL <- paste(orgURL, alldata$path[i], sep='')
  urlExists = url.exists(icookURL)
  
  if(urlExists)
  {
    html = getURL(icookURL, ssl.verifypeer = FALSE, encoding='UTF-8')
    xml = htmlParse(html, encoding='UTF-8')
    view = xpathSApply(xml, "//span[@class=\"views-count count-tooltip\"]", xmlValue)
    name <- paste('./allTex/c', i, '.txt', sep='')
    write(view, name)
    
  }
}