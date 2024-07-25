<div align="center">
<h1>DNS over HTTPS(DoH) For Linux</h1>
</div>

### VPS 为什么要使用DoH加密DNS？
 - 购买的VPS服务器，系统默认使用UDP来解析，这就导致DNS可能会被污染/劫持/解析乱飘
 - 比如：科学上网时，香港的VPS，DNS泄漏检测里会混有台湾，韩国的VPS，会混有日本等
 - 比如：Telegram手机APP，你是不是碰到过转圈圈刷不出来，退出软件，再进去就又正常了？
 - 那就赶紧给你的VPS换上DoH吧，还你一个干净，安全，高效的网络环境

--------------

### 加密DNS

**Aliyun DNS-over-HTTPS:** `https://223.5.5.5/dns-query` **&** `https://223.6.6.6/dns-query`

**Tencent DNS-over-HTTPS:** `https://1.12.12.12/dns-query` **&** `https://120.53.53.53/dns-query`

**Cloudflare DNS-over-HTTPS:** `https://1.1.1.1/dns-query` **&** `https://1.0.0.1/dns-query`

**Google DNS-over-HTTPS:** `https://8.8.8.8/dns-query` **&** `https://8.8.4.4/dns-query`


--------------


### 如何使用

- 一键安装命令（CentOS/Ubuntu/Debian）
```
bash <(curl -sSL "https://raw.githubusercontent.com/WukongMaster/DNS-over-HTTPS-For-Linux/main/DNSProxy.sh")
```

- 修改系统DNS（填写：127.0.0.1）
```
bash <(curl -sSL "https://raw.githubusercontent.com/WukongMaster/DNS-over-HTTPS-For-Linux/main/ChangeDNS.sh")
```

--------------

### 如何验证
- 安装 nslookup
```
apt install dnsutils
```
- 验证 DNS 
```
nslookup google.com
```
解析返回地址：127.0.0.1#53，就表示DoH已经正常工作了

--------------
