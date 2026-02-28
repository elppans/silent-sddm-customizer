# 🐧 SDDM Silent Customizer (Arch Linux)

Scripts para automatizar a rotação de temas do pacote **Silent SDDM** e gerenciar avatares de usuário de forma simples e eficiente no Arch Linux.

## ✨ Funcionalidades

* **`sddm-silent-customizer.sh`**: Seleciona aleatoriamente um dos estilos do tema Silent a cada login.
* **`faceconv`**: Utilitário para converter qualquer imagem para o formato exato exigido pelo SDDM (`.face.icon`), seguindo os padrões técnicos de 8-bit RGBA e redimensionamento 1:1.

---

## 🚀 Instalação e Configuração

### 1. Preparando o Ambiente

Para que os scripts funcionem sem interrupções de permissão, configure o grupo `sddm`:

```bash
# Cria o grupo sddm caso não exista e adiciona seu usuário
sudo groupadd -f sddm
sudo usermod -aG sddm $USER

# Ajusta as permissões do arquivo de configuração do tema
sudo chgrp sddm /usr/share/sddm/themes/silent/metadata.desktop
sudo chmod 664 /usr/share/sddm/themes/silent/metadata.desktop

```

### 2. Rotação Automática de Temas

Mova o script de rotação para o diretório de inicialização do sistema:

```bash
sudo cp sddm-silent-customizer.sh /etc/profile.d/
sudo chmod +x /etc/profile.d/sddm-silent-customizer.sh

```

### 3. Gerenciador de Avatar (`faceconv`)

O SDDM requer especificações rigorosas para a imagem de usuário. Este script utiliza o **ImageMagick** para automatizar o processo.

**Dependência:** `sudo pacman -S imagemagick`

**Uso:**

```bash
./faceconv minha_imagem.jpg

```

*O script salva o resultado em `~/.face.icon` e ajusta automaticamente a permissão de execução da sua Home (`chmod a+x $HOME`) para garantir que o SDDM consiga ler o arquivo.*

---

## 🛠️ Detalhes Técnicos

### Padrão do Ícone de Usuário

O script `faceconv` garante as seguintes especificações descobertas em testes:

* **Resolução:** 256x256 pixels (com crop inteligente centralizado).
* **Formato:** PNG 8-bit/color RGBA (PNG32), non-interlaced.
* **Localização:** `$HOME/.face.icon`.

### Manipulação Segura de Arquivos

A rotação de temas evita o uso de `sed -i` diretamente em diretórios do sistema para prevenir erros de permissão com arquivos temporários, utilizando redirecionamento de saída padrão para garantir a integridade do `metadata.desktop`.

---

## 📄 Licença

Este projeto está licenciado sob a **Licença MIT** - consulte o arquivo [LICENSE](https://www.google.com/search?q=LICENSE) para detalhes.

---

## 📸 Créditos

Baseado no tema original [SilentSDDM](https://github.com/uiriansan/SilentSDDM) desenvolvido por uiriansan.

