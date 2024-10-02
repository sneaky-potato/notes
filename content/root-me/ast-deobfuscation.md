# AST - Deobfuscation

## Initial Attempt

The json is fairly easy to read but the problem is the amount of lines and verbosity, so I delegated this task to chatGPT

## De-obfuscation

Give the body elements one by one to GPT to reconstruct the code, until you find the `gen_sensor` function definition

```javascript
function gen_sensor() {
    let sens = [10] + [45] + [65] + [78] + [47];
    if ((sens >>= 4) == 20) {
        sens << 4;
    }
    let sensor = (function () {
        return [
            65353704, 65353663, 65353663, 65353707, 65353680, 65353701, 
            65353663, 65353709, 65353680, 65353706, 65353710, 65353724, 
            65353718, 65353680, 65353707, 65353706, 65353696, 65353709, 
            65353705, 65353722, 65353724, 65353708, 65353710, 65353723, 
            65353702, 65353696, 65353697
        ];
    })()
    .map(c => String.fromCharCode(c ^ sens))
    .join('');
    return sensor;
}
```

Running this function in the browser console reveals the flag
