#!/bin/bash

echo "for signer"

keyPath="/Users/liudan/workSpace/key/dan.keystore"
keyName="dankey"
keyPass="perfect1243"
echo "输入要签名的包"

read package
newName=${package%%.*}"-Signed.apk"

jarsigner -verbose -keystore $keyPath -signedjar $newName $package $keyName -storepass $keyPass


