#!/bin/bash

# IMXT 1.0
# Script para otimizar uso da ferramenta steghide.

[ $UID -ne '0' ] && { echo "ERRO: Necessário ter acesso root."; exit 1 ;}

usage() {
	echo "                            ░▀█▀░█▄█░█░█░▀█▀"
    echo "                            ░░█░░█░█░▄▀▄░░█░"
    echo "                            ░▀▀▀░▀░▀░▀░▀░░▀░"
	echo ""
    echo " Uso: imxt.sh [opção] [argumentos]"
    echo "\nOpções:"
    echo "  -e <imagem> <mensagem.txt> <senha>   Esconde o texto dentro da imagem"
    echo "  -x <imagem> <senha>                  Extrai o texto oculto da imagem"
    echo "  -c <imagem>                          Verifica se há mensagem oculta na imagem"
    echo "  -i                                   Exibe algoritmos e modos suportados"
	echo "  -h                                   Uso"
    exit 1
}

if [ $# -eq 0 ]; then
    usage
fi

if ! command -v steghide &> /dev/null; then
    echo "ERRO: 'steghide' não encontrado. Instale o steghide usando 'apt install steghide'."
    exit 1
fi

# Parâmetros
while getopts ":e:x:c:ih" opt; do
    case ${opt} in
        e)
            if [ $# -ne 4 ]; then
                echo "ERRO: Uso incorreto do parâmetro -e"
                usage
            fi
            if [ ! -f "$2" ] || [ ! -f "$3" ]; then
                echo "ERRO: Arquivo(s) não encontrado(s). Verifique os caminhos."
                exit 1
            fi
            steghide embed -cf "$2" -ef "$3" -p "$4" && echo "[*] Mensagem ocultada com sucesso em '$2'!"
            ;;
        x)
            if [ $# -ne 3 ]; then
                echo "ERRO: Uso incorreto do parâmetro -x"
                usage
            fi
            if [ ! -f "$2" ]; then
                echo "ERRO: Arquivo de imagem não encontrado."
                exit 1
            fi
            steghide extract -sf "$2" -p "$3" && echo "[*] Mensagem extraída com sucesso!"
            ;;
        c)
            if [ $# -ne 2 ]; then
                echo "ERRO: Uso incorreto do parâmetro -c"
                usage
            fi
            if [ ! -f "$2" ]; then
                echo "ERRO: Arquivo de imagem não encontrado."
                exit 1
            fi
            steghide info "$2" && echo "[*] Verificação concluída."
            ;;
        i)
            steghide encinfo && echo "[+] Algoritmos e modos suportados."
            ;;
        h)
            usage
            ;;
        *)
            echo "Opção inválida: -$OPTARG" >&2
            usage
            ;;
    esac
done
