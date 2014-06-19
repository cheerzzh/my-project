# -*- coding: utf-8 -*- 
from bs4 import BeautifulSoup
import httplib2
import urllib
import re
import time

h = httplib2.Http('.cache')
#start node
url = "http://supersupergirl.openrice.com"

#nodes need to be visited
urls = [url]
#nodes has been visited
visited = [url]
#current node "guanzhu" page need to be visited
pageurl = []
#information about known nodes
network = []    
count = 0

#url pattern
pattern1 = re.compile(r'http://\S*.openrice.com$')
pattern2 = re.compile(r'http://www.openrice.com/restaurant/userinfo')
pattern3 = re.compile(r'//\S*.openrice.com$')
pattern4 = re.compile(r'/restaurant/userinfo.htm')

#info pattern
location = re.compile(u"最常於\D*出沒")
preference = re.compile(u'最鍾意\D*。')
shouweishipin = re.compile(u'\d*次成為首位寫食評會員')
shipinshumu = re.compile(u'食評數目\d*')
bianjituijie = re.compile(u'編輯推介數目\d*')
huiyuantuijie = re.compile(u'會員推介次數\d*')
renqizhishu = re.compile(u'人氣指數\d*')
liuyanshumu = re.compile(u'留言數目\d*')
shangzaixiangpian = re.compile(u'上載相片\d*')
shangzaiyingpian = re.compile(u'上載影片\d*')
tuijieshipin = re.compile(u'推介的食評\d*')
canting = re.compile(u'我的餐廳\d*')
guanzhu = re.compile(u'關注\d*')
fensi = re.compile(u'粉絲\d*')

while len(urls)>0:
    try:
        print("count="+str(count))
        print("urls[0]:" + urls[0])
        if (pattern1.match(urls[0])):
            string = urllib.parse.urljoin(urls[0], "/home/bookmarkuser.htm")
        if (pattern2.match(urls[0])):
            string = re.sub('restaurant/userinfo', 'gourmet/bookmarkuser', urls[0])
        print("str:" + string)
        response, htmltext = h.request(string) #enter into "關注"
        print("hi")
    except:
        print("fail")

    soup = BeautifulSoup(htmltext)
    info_group = soup.find_all("div", "info")
    temp = "".join(info_group[1].get_text().split())
    info = string+info_group[0].get_text() + temp #get current node information
    print(info)
    network.append({'info': info, 'follow':set()}) #update network
    

    #get current node's "關注"(at most two pages, 30 nodes)
    pages = soup.find_all("a", "number")   
    if len(pages)==0:
        pageurl.append(string)
    else:
        pageurl.append(string)
        for i in range(len(pages)):
            pageurl.append(urllib.parse.urljoin(urls[0], pages[i].get('href')))
    
    print("#pageurl")
    print(pageurl)
    
    follows = []
    while len(pageurl)>0:
        time.sleep(1)
        response, htmltext = h.request(pageurl[0])
        soup = BeautifulSoup(htmltext) 
        for tag in soup.find_all("span", "menpiccomment"):
            follow = tag.find_previous_sibling('a').get('href')
            if (pattern3.match(follow)):
                follow= urllib.parse.urljoin("http:", follow)
            if (pattern4.match(follow)):
                follow= urllib.parse.urljoin("http://www.openrice.com", follow)
            
            print(follow)
            follows.append(follow)
            
            if follow not in visited:
                #print("#not in")
                urls.append(follow)
                #print(urls)
                visited.append(follow)
                network[count]['follow'].add(len(visited))
            else:
                #print("#in")
                index = visited.index(follow)+1
                network[count]['follow'].add(index)
                
        pageurl.pop(0)
        
    urls.pop(0)
    count = count+1

    #if count>5: #control the number of nodes
    #    break

with open('C:/Users/cheerzzh/Desktop/4190/result4.txt', mode='w', encoding = 'utf-8') as result_file:
    for i in range(len(network)):
        result_file.write('ID:')
        result_file.write(str(i))
        result_file.write('\n')
        result_file.write('info:')
        result_file.write(''.join(network[i]['info']).strip())
        result_file.write('\n')
        result_file.write('follow:')
        tmp = list(network[i]['follow'])
        n=0
        s=''
        while n < len(tmp):
            s += str(tmp[n])
            s += ' '
            n += 1      
        result_file.write(s)
        result_file.write('\n')
        result_file.write('\n')
#print(visited)

from tempfile import TemporaryFile
from xlwt3 import Workbook
book = Workbook()
book.add_sheet('Node Graph')
book.add_sheet('Edge Graph')
edge_row = 0
for i in range(len(network)):
    sheet1 = book.get_sheet(0)
    for k in range(25):
        sheet1.col(k).width = 5000
        
    sheet1.write(i+1, 0, i+1)
    m = re.search(location, network[i]['info'])
    if m != None:
        loca = m.group(0)[3:-2].split('，')
        for j in range(len(loca)):
            sheet1.write(i+1, j+1, loca[j])
        
    m = re.search(preference, network[i]['info'])
    if m != None:
        food = m.group(0)[3:-1].split('，')
        print(food)
        for z in range(len(food)):
            sheet1.write(i+1, z+5, food[z])
    else:
        print("error")

    m = re.search(shouweishipin, network[i]['info'])
    if m!= None:
        number = m.group(0)[:-10]
        print(number)
        sheet1.write(i+1, 30, number)
    else:
        print("error")

    m = re.search(shipinshumu, network[i]['info'])
    if m!= None:
        number = m.group(0)[4:]
        print(number)
        sheet1.write(i+1, 31, number)
    else:
        print("error")

    m = re.search(bianjituijie, network[i]['info'])
    if m!= None:
        number = m.group(0)[6:]
        print(number)
        sheet1.write(i+1, 32, number)
    else:
        print("error")

    m = re.search(huiyuantuijie, network[i]['info'])
    if m!= None:
        number = m.group(0)[6:]
        print(number)
        sheet1.write(i+1, 33, number)
    else:
        print("error")

    m = re.search(renqizhishu, network[i]['info'])
    if m!= None:
        number = m.group(0)[4:]
        print(number)
        sheet1.write(i+1, 34, number)
    else:
        print("error")
    
    m = re.search(liuyanshumu, network[i]['info'])
    if m!= None:
        number = m.group(0)[4:]
        print(number)
        sheet1.write(i+1, 35, number)
    else:
        print("error")


    m = re.search(shangzaixiangpian, network[i]['info'])
    if m!= None:
        number = m.group(0)[4:]
        print(number)
        sheet1.write(i+1, 36, number)
    else:
        print("error")


    m = re.search(shangzaiyingpian, network[i]['info'])
    if m!= None:
        number = m.group(0)[4:]
        print(number)
        sheet1.write(i+1, 37, number)
    else:
        print("error")

    m = re.search(tuijieshipin, network[i]['info'])
    if m!= None:
        number = m.group(0)[5:]
        print(number)
        sheet1.write(i+1, 38, number)
    else:
        print("error")
    

    m = re.search(canting, network[i]['info'])
    if m!= None:
        number = m.group(0)[4:]
        print(number)
        sheet1.write(i+1, 39, number)
    else:
        print("error")

    m = re.search(guanzhu, network[i]['info'])
    if m!= None:
        number = m.group(0)[2:]
        print(number)
        sheet1.write(i+1, 40, number)
    else:
        print("error")
    
    m = re.search(fensi, network[i]['info'])
    if m!= None:
        number = m.group(0)[2:]
        print(number)
        sheet1.write(i+1, 41, number)
    else:
        print("error")

    m = re.search("bookmarkuser.htm\?userid=\d*", network[i]['info'])
    if m!=None:
        ID = m.group(0)[24:]
        print(ID)
        sheet1.write(i+1, 42, ID)
    else:
        m = re.search(":[\s\S]*.openrice", network[i]['info'])
        if m!=None:
            ID = m.group(0)[3:-9]
            print(ID)
            sheet1.write(i+1, 42, ID)
        else:
            print("error")
        
    sheet2 = book.get_sheet(1)
    
    for e in network[i]['follow']:
        if e <= len(network):
            sheet2.write(edge_row, 0, i+1)
            sheet2.write(edge_row, 1, e)
            edge_row += 1

    

book.save('network4.xls')
book.save(TemporaryFile())
