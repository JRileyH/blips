#!/bin/bash
if ! command -v godot &> /dev/null
then
    # Install Godot
    wget -q https://downloads.tuxfamily.org/godotengine/3.4.2/Godot_v3.4.2-stable_linux_headless.64.zip
    unzip Godot_v3.4.2-stable_linux_headless.64.zip
    chmod +x Godot_v3.4.2-stable_linux_headless.64
    mv Godot_v3.4.2-stable_linux_headless.64 godot
    # Install
    wget -q https://downloads.tuxfamily.org/godotengine/3.4.2/Godot_v3.4.2-stable_export_templates.tpz
    mkdir -p ~/.local/share/godot/templates
    unzip Godot_v3.4.2-stable_export_templates.tpz -d ~/.local/share/godot/templates
    mv ~/.local/share/godot/templates/templates ~/.local/share/godot/templates/3.4.2.stable
    # Export
    ./godot --export HTML5 project.godot "build/index.html"
else
    godot --export HTML5 project.godot "build/index.html"
fi
