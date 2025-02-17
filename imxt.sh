#!/bin/bash

# IMXT 1.0
# Script para otimizar uso da ferramenta steghide.

[ $UID -ne '0' ] && { echo -e "\e[1;31mE:\e[0m Necessário ter acesso root."; exit 1 ;}

usage() {
	echo
    echo -e "                            ░▀█▀░█▄█░█░█░▀█▀"
    echo -e "                            ░░█░░█░█░▄▀▄░░█░"
    echo -e "                            ░▀▀▀░▀░▀░▀░▀░░▀░"
    echo
    echo -e " Uso: imxt.sh [opção] [argumentos]"
    echo -e " Opções:"
    echo -e "  -e <imagem> <mensagem.txt> <senha>   Esconde o texto dentro da imagem"
    echo -e "  -x <imagem> <senha>                  Extrai o texto oculto da imagem"
    echo -e "  -c <imagem>                          Verifica se há mensagem oculta na imagem"
    echo -e "  -i                                   Exibe algoritmos e modos suportados"
	echo -e "  -h                                   Uso\n"
    exit 1
}

if [ $# -eq 0 ]; then
    usage
fi

if ! command -v steghide &> /dev/null; then
    echo -e "\e[1;31mE:\e[0m 'steghide' não encontrado. Instale o steghide usando 'apt install steghide'."
    exit 1
fi

# Parâmetros
while getopts ":e:x:c:ih" opt; do
    case ${opt} in
        e)
            if [ $# -ne 4 ]; then
                echo -e "\e[1;31mE:\e[0m Uso incorreto do parâmetro -e"
                usage
            fi
            if [ ! -f "$2" ] || [ ! -f "$3" ]; then
                echo -e "\e[1;31mE:\e[0m Arquivo(s) não encontrado(s). Verifique os caminhos."
                exit 1
            fi
            steghide embed -cf "$2" -ef "$3" -p "$4" && echo "[*] Mensagem ocultada com sucesso em '$2'!"
            ;;
        x)
            if [ $# -ne 3 ]; then
                echo -e "\e[1;31mE:\e[0m Uso incorreto do parâmetro -x"
                usage
            fi
            if [ ! -f "$2" ]; then
                echo -e "\e[1;31mE:\e[0m Arquivo de imagem não encontrado."
                exit 1
            fi
            steghide extract -sf "$2" -p "$3" && echo "[*] Mensagem extraída com sucesso!"
            ;;
        c)
            if [ $# -ne 2 ]; then
                echo -e "\e[1;31mE:\e[0m Uso incorreto do parâmetro -c"
                usage
            fi
            if [ ! -f "$2" ]; then
                echo -e "\e[1;31mE:\e[0m Arquivo de imagem não encontrado."
                exit 1
            fi
            steghide info "$2" && echo "[*] Verificação concluída."
            ;;
        i)
            steghide encinfo && echo -e "\n[+] Algoritmos e modos suportados."
            ;;
        h)
            usage
            ;;
        *)
            echo -e "\e[1;31mE:\e[0m Opção inválida: -$OPTARG" >&2
            usage
            ;;
    esac
done
