#!/bin/bash

echo "Bienvenido, ¿qué quieres hacer? 
1) Actualizar el sistema
2) Crear permisos
3) Crear usuarios
4) Eliminar carpeta
5) Eliminar usuarios
6) Salir"

read -p "Selecciona una opción: " respuesta

if [ "$respuesta" = "1" ]; then
    sudo apt update && sudo apt upgrade -y
    fi

if [ "$respuesta" = "2" ]; then
    echo "Has elegido crear permisos."

    read -p "'Introduce la ruta completa donde crear la carpeta (Estas en el directorio /home/batoi/Escritorio/scripts) : '" ruta_carpeta

    if [ -d "$ruta_carpeta" ]; then
        echo "La carpeta '$ruta_carpeta' ya existe."
        exit 1
    fi

    sudo mkdir -p "$ruta_carpeta"
    echo "Carpeta '$ruta_carpeta' creada correctamente."

    read -p "¿Que usuarios solo pueden verlo?" respuesta_permisos

    if ! grep -q "^$respuesta_permisos:" /etc/group; then
        echo "El grupo '$respuesta_permisos' no existe. Creándolo..."
        if sudo groupadd "$respuesta_permisos"; then
            echo "Grupo '$respuesta_permisos' creado correctamente."
        else
            echo "Error: No se pudo crear el grupo '$respuesta_permisos'. Verifica tus permisos."
            exit 1
        fi
    fi

    sudo chown root:"$respuesta_permisos" "$ruta_carpeta"

    sudo chmod 750 "$ruta_carpeta"
    echo "Permisos asignados correctamente."

    echo "Carpeta '$ruta_carpeta' creada correctamente y solo visible para el grupo '$respuesta_permisos'."

elif [ "$respuesta" = "3" ]; then
    
    echo "Has elegido crear usuarios."
    
    
    read -p "Introduce el nombre del usuario que quieres crear: " nombre_usuario
    

    read -p "Introduce el nombre del grupo donde asignar al usuario: " nombre_grupo
    
    
    if grep -q "^$nombre_grupo:" /etc/group; then
        echo "El grupo '$nombre_grupo' ya existe."
    else
        echo "El grupo '$nombre_grupo' no existe. Creándolo..."
        if sudo groupadd "$nombre_grupo"; then
            echo "Grupo '$nombre_grupo' creado correctamente."
        else
            echo "Error: No se pudo crear el grupo '$nombre_grupo'. Verifica tus permisos."
            exit 1
        fi
    fi
    
    if id "$nombre_usuario" &>/dev/null; then
        echo "El usuario '$nombre_usuario' ya existe. Asignándolo al grupo '$nombre_grupo'."
        sudo usermod -aG "$nombre_grupo" "$nombre_usuario"
        echo "Usuario '$nombre_usuario' asignado al grupo '$nombre_grupo'."
    else
        echo "Creando el usuario '$nombre_usuario' y asignándolo al grupo '$nombre_grupo'..."
        if sudo useradd -m -g "$nombre_grupo" "$nombre_usuario"; then
            echo "Usuario '$nombre_usuario' creado y asignado al grupo '$nombre_grupo'."
        else
            echo "Error: No se pudo crear el usuario '$nombre_usuario'. Verifica tus permisos."
            exit 1
        fi
    fi

elif [ "$respuesta" = "4" ]; then
    echo "Has elegido eliminar carpeta."   
    read -p "Introduce la ruta completa de la carpeta a eliminar: " ruta_carpeta

    if [ -d "$ruta_carpeta" ]; then
        sudo rm -rf "$ruta_carpeta"
        echo "Carpeta '$ruta_carpeta' eliminada correctamente."
    else
        echo "La carpeta '$ruta_carpeta' no existe."
        exit 1
    fi

elif [ "$respuesta" = "5" ]; then
    echo "Has elegido eliminar usuarios."
    read -p "Introduce el nombre del usuario que quieres eliminar: " nombre_usuario

    if id "$nombre_usuario" &>/dev/null; then
        sudo userdel -r "$nombre_usuario"
        echo "Usuario '$nombre_usuario' eliminado correctamente."
    else
        echo "El usuario '$nombre_usuario' no existe."
        exit 1
    fi

elif [ "$respuesta" = "6" ]; then
    echo "Has elegido salir."
    exit 0


else
    echo "Opción no válida. Inténtalo de nuevo"
fi
