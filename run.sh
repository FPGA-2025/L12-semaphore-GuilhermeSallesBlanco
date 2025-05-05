#!/bin/bash
if [ -z "$1" ]; then
    echo "Erro: É preciso especificar o número do teste"
    exit 1
fi
iverilog -o tb *.v
rm -f saida.out
cp test/teste$1.txt teste.txt
./tb > saida.out
cp saida.out test/saida$1.out
cp saida.vcd test/saida$1.vcd
rm -rf saida.out saida.vcd

if diff -Z <(grep '===' test/saida$1.out) test/saida$1.ok >/dev/null; then
    echo "OK"
    exit 0
else
    echo "ERRO"
    exit 1
fi
