#!/bin/bash
fast_chr() {
    local __octal
    local __char
    printf -v __octal '%03o' "$1"
    printf -v __char \\"$__octal"
    REPLY=$__char
}

function unichr {
    local c=$1    # Ordinal of char
    local l=0    # Byte ctr
    local o=63    # Ceiling
    local p=128    # Accum. bits
    local s=''    # Output string

    printf "[%x] " "$c"
    (( c < 0x80 )) && { fast_chr "$c"; echo -n "$REPLY"; return; }

    while (( c > o )); do
        fast_chr $(( t = 0x80 | c & 0x3f ))
        s="$REPLY$s"
        (( c >>= 6, l++, p += o+1, o>>=1 ))
    done

    fast_chr $(( t = p | c ))
    echo -n "$REPLY$s "
}

## test harness
for (( i=0x2600; i<0x26ff; i++ )); do
#for (( i=0x2500; i<0x25d0; i++ )); do
#for (( i=0xe0a0; i<0xe0e0; i++ )); do
#for (( i=0xfad0; i<0xfaf0; i++ )); do
    unichr $i
    if [[ $(($i % 16)) -eq 0 ]];
        then
            echo
        fi
done

