RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"
BLUE="\033[34m"
CYAN="\033[36m"
RESET="\033[0m"

menu() {
    echo -e "${BLUE} =================================================== ${RESET}"
    echo -e "${BLUE} ===========         BASHPANEL         ============= ${RESET}"
    echo -e "${BLUE} =================================================== ${RESET}"
    echo -e "${BLUE} ======      Escolha uma das opções abaixo    ====== ${RESET}"
    echo -e "${BLUE} =================================================== ${RESET}"
    echo -e ""
    echo -e "${RED} 1)${RESET}${CYAN} - Iniciar o MySQL server ${RESET}"
    echo -e "${RED} 2)${RESET}${CYAN} - Iniciar o PhpMyAdmin ${RESET}"
    echo -e "${RED} 3)${RESET}${CYAN} - Iniciar o PostgreSQL server ${RESET}"
    echo -e "${RED} 4)${RESET}${CYAN} - Sair ${RESET}" 
}

mariadb() {
    status=$(sudo systemctl is-active mariadb)

    if [ "$status" == "active" ]; then 
        echo -e "${GREEN}Mysql está ativado! Deseja desativar o serviço? (y/n): ${RESET}"
        read opcao

        if [ "$opcao" == "y" ]; then 
            sudo systemctl stop mariadb
            echo -e "${RED}O serviço foi desativado!${RESET}"
        else
            echo -e "${YELLOW}O serviço continuará ativo.${RESET}"
        fi
    else
        sudo systemctl start mariadb
        echo -e "${GREEN}O serviço foi iniciado!${RESET}"
    fi    
}

phpmyadmin() {
    port=8000
    running=$(lsof -i -P -n | grep ":$port")
    if [ -n "$running" ]; then
        echo -e "${GREEN}PhpMyAdmin está rodando na porta $port, deseja desativar o serviço? (y/n):${RESET}"
        read opcao

        if [ "$opcao" == "y" ]; then
            # Corrigido o comando para capturar o PID do processo corretamente
            pdi=$(ps aux | grep "php -S localhost:$port" | grep -v grep | awk '{print $2}')
            kill "$pdi"
            echo -e "${RED}O serviço foi desativado!${RESET}"
        else
            echo -e "${YELLOW}O serviço continuará ativo.${RESET}"
        fi    

    else
        echo -e "${GREEN}O serviço será iniciado na porta $port!${RESET}"
        echo -e "${YELLOW}Acesse em: http://localhost:$port${RESET}"
	cd ~/Programas/phpMyAdmin-5.2.1-all-languages 
        php -S "localhost:$port" &
        # Espera 2 segundos para garantir que o servidor tenha tempo de iniciar
        sleep 2
    fi
}

pgsql(){
	status=$(sudo systemctl is-active postgresql)

	if [ "$status" == "active" ]; then
	
		echo -e "${GREEN}O servidor postgresql está ativ0, deseja desativar o sevriço?(y, n):${RESET}"
		read opcao
	
		if [ "$opcao" == "y" ]; then
	
			sudo systemctl stop postgresql
			sleep 2
			echo -e "${RED}O serviço foi desativado!${RESET}"
	
		else
			echo -e "${GREEN}O serviço continuará ativo!${RESET}"
		fi
	
	else
		echo -e "${YELLOW}O servidor postgresql será iniciado!${RESET}"
		sudo systemctl start postgresql
		sleep 2
		echo -e "${GREEN}O servidor postgresql foi iniciado!${RESET}"
	
	 fi

}

while true; do
    menu
    echo -n -e "${CYAN}Escolha uma opção: ${RESET}"
    read opcao

    case $opcao in
        1)
            mariadb
            ;;
        2)
            phpmyadmin
            ;;
	3)
	    pgsql
	    ;;	
        4)
            exit
            ;;    
        *)
            echo -e "${RED}Opção inválida!${RESET}"
            ;;
    esac 

    echo -e "${YELLOW}Pressione Enter para continuar...${RESET}"
    read
done
