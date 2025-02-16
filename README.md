# Projeto_AOC

## Introdução
Esse projeto busca implementar um twin-stick shooter, baseado em jogos como o Smash TV (1990) e o Vampire Survivors (2022), em x86-16bits para o MSDos

Para executar o programa, recomenda-se o uso do DOSBox, disponível em: https://www.dosbox.com/wiki/Releases

## Execução 
Mova os conteúdos desse repositório para C:\Assembly, e então, dentro do DOSBox execute:
mount c C:\Assembly
C:
boxshv.com

## Desenvolvimento
Esse projeto utilizou os seguintes recursos como referência: 
https://github.com/adamsmasher/sokobanDOS/tree/master (Tutorial de criação de jogos em assembly x86-16bits para o MSDos)
https://web.archive.org/web/20140702154140/http://www.brackeen.com/vga/index.html 
https://github.com/resetreboot/mineassembly (Implementação do jogo "Campo Minado" em assembly x86-16bits para o MSDos)

Resolução da tela: 320x200

Palheta de cores para o int 13h https://imgur.com/a/vga-256-color-chart-int13h-gMoQE5T 
Asset Pack utilizado: https://ivoryred.itch.io/pico-8-character-sprite 


Para construir o arquivo boxshv, use o comando:
nasm boxshv.asm -o boxshv.com