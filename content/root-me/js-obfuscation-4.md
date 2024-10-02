# JS - Obfuscation 4

## Initial Attempt

Deobfuscate the script using some powerful tools of vim -
- Replace French characters with English ones
- Insert newlines after semicolons - `:s/;/;\r/g`
- Correct function definitions by inserting newlines and tabs - `:%s/{/{\r\t/g` and `:%s/}/}\r/g`
- Correct for loops by removing the unnecessary newlines - `:%s/for(\(.*;\)\n\(.*;\)\n\(.*\))/for (\1 \2 \3)` (another reason to thank yourself for shifting to nvim)
- Indent the lines inside for loops and functions
- Replace function names from main code to function definitions - `:%s/\<_______\>/fun`, same for the others and variable names

```javascript
var a= "\x71\x11\x24\x59\x8d\x6d\x71\x11\x35\x16\x8c\x6d\x71\x0d\x39\x47\x1f\x36\xf1\x2f\x39\x36\x8e\x3c\x4b\x39\x35\x12\x87\x7c\xa3\x10\x74\x58\x16\xc7\x71\x56\x68\x51\x2c\x8c\x73\x45\x32\x5b\x8c\x2a\xf1\x2f\x3f\x57\x6e\x04\x3d\x16\x75\x67\x16\x4f\x6d\x1c\x6e\x40\x01\x36\x93\x59\x33\x56\x04\x3e\x7b\x3a\x70\x50\x16\x04\x3d\x18\x73\x37\xac\x24\xe1\x56\x62\x5b\x8c\x2a\xf1\x45\x7f\x86\x07\x3e\x63\x47";
function xor(x,y){
	return x^y;
}
function setbits(y){
    var z = 0;
    for (var i=0; i<y; i++) {
        z += Math.pow(2,i);
    }
    return z;
}
function setbits2(y){
    var z = 0;
    for (var i=8-y; i<8; i++) {
        z += Math.pow(2,i);
    }
    return z
}
function ____(x,y){
    y = y % 8;
    b = setbits(y);
    b = (x & b) << (8-y);
    return (b) + (x >> y);
}
function trick(x,y){
    y = y % 8;
    b = setbits2(y);
    b = (x & b) >> (8-y);
    return ((b) + (x << y)) & 0x00ff;
}
function fun(src,key){
    res = "";
    for (var i=0; i<src.length; i++) {
        c = src.charCodeAt(i);
        if(i != 0){
            t = res.charCodeAt(i-1)%2;
            switch(t){
                case 0:cr = xor(c, key.charCodeAt(i % key.length));
                    break;
                case 1:cr = trick(c, key.charCodeAt(i % key.length));
                    break;
            }
        }
        else{
            cr = xor(c, key.charCodeAt(i % key.length));
        }
        res += String.fromCharCode(cr);
    }
    return res;
}
function gun(arg){
    var n=0;
    for (var i=0; i<arg.length; i++) {
        n+=arg["charCodeAt"](i)}
    if(n==8932){
        var d=window.open("","","\x77\x69\x64\x74\x68\x3d\x33\x30\x30\x2c\x68\x65\x69\x67\x68\x74\x3d\x32\x20\x30");
        d.document.write(arg)}
    else{
        alert("Mauvais mot de passe!")}
}
gun(fun(a,prompt("Mot de passe?")));
```
