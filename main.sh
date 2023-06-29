#!/bin/bash

BLUE="\e[34m"
GREEN="\e[32m"
YELLOW="\e[33m"
RED="\e[31m"
ENDCOLOR="\e[0m"

resize -s 23 126

while true; do
    clear

    # Replace the ASCII art placeholder with your desired ASCII art
    ascii_art="
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%#............,%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%....*%%%%%%#..../%%%%%
%%%*            (%%%%%%%%%%%%%%%%%%%%%%%%%%%(   %%%%%%%%%%%%%%%%%%%%%%%*   %%%%%%%%%%%%%%%%%%%%%%%%%%%.    %%%%/    #%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   ,%%%%%%%%%%%%%%%/   %%%%,  .%%%%%%%%%%%%%%%%%%%%%%%%%%%%(    #%     %%%%%%%%
%%%%************%   %%%%%%    //  (,,)  %%%#   #***/%%%%%***%##   ,##       %%(*,,*(%%%%%***#/,,,/%%%%%%%        #%%%%%%%%%
%%%/            *(   #%%%#   /           %%   ,%   #%%%%.   %%             %            /           %%%%%%*     %%%%%%%%%%%
%%%%(     (%%%%%%%.  ,%%*   #   ,%%%%%.  .#   (.  .%%%%%   (%%   .%%%#   %   .%%%%%,   %   ,%%%%/   #%%%%        (%%%%%%%%%
%%%%%%%(     #%%%%%   #   /%#   %%%%%%   *,  .%   /%%%%.   %%(   %%%%.  .#   (%%%%%   ./   %%%%%.  .%%%/    #%     %%%%%%%%
%%%%%%%%%%,   #%%%%      #%%%,          /#   (%           /%%/    , %   #%/    ..    *%.  .%%%%#   (%%     %%%%/    (%%%%%%
%%%%%%%%%%%%% %%%%%%   ,%%%%%%%%      %%%*   %%%%%_____***%%%%    .#.  .%%%%%#.  ,%%%%(   %%%%%,   %(    /%%%%%%%    .%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    "

    echo -e "${BLUE}$ascii_art${ENDCOLOR}"

    cpu_temps=$(sensors --no-adapter | awk '/Core [0-9]+:/ {print $3}' | tr -d '+°C')
    total_cores=0
    total_temp=0
    temp_array=()

    for temp in $cpu_temps; do
        total_temp=$(echo "$total_temp + $temp" | bc)
        total_cores=$((total_cores + 1))
        temp_array+=("$temp")
    done

    if [[ $total_cores -gt 0 ]]; then
        average_temp=$(echo "scale=2; $total_temp / $total_cores" | bc)
    fi

    echo -e "\n${GREEN}CPU Temperatures:${ENDCOLOR}"
    for ((i=0; i<${#temp_array[@]}; i++)); do
        temp="${temp_array[$i]}"
        if (( $(echo "$temp >= 70" | bc -l) )); then
            color=$RED
        elif (( $(echo "$temp >= 50" | bc -l) )); then
            color=$YELLOW
        else
            color=$GREEN
        fi
        echo -ne "$color$temp°C${ENDCOLOR}"
        if (( $i < ${#temp_array[@]} - 1 )); then
            echo -ne ", "
        fi
    done

    echo -e "\n"
    echo -e "${GREEN}Average Temperature: ${color}$average_temp°C${ENDCOLOR}"

    sleep 1
done

