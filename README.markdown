HNCSD
===

项目简介
---
从[http://www.hncsjj.gov.cn/QueryJDCWZOther.aspx](http://www.hncsjj.gov.cn/QueryJDCWZOther.aspx)抓取数据,不处理验证码,只是代理与数据解析.  
基于[Sinatra](https://github.com/sinatra/sinatra/)框架编写,采集用Mechanize.

开发心得
---
* 采集asp.net站提交表单数据一定要把 `__VIEWSTATE`, `__EVENTVALIDATION`, 还有点击按钮的name与value给带上(按钮是必须的)
