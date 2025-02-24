# Projeto_AOC

## Introdução
![alt text](https://i.imgur.com/NUMF6R3.png)

Esse projeto buscou implementar um shoot-em-up baseado em jogos como Space Invaders para o MSDos de 16 bits <br /> 

Para executar o programa, recomenda-se o uso do DOSBox, disponível em: https://www.dosbox.com/wiki/Releases

## Execução 
Mova os conteúdos desse repositório para alguma pasta (usaremos C:\Assembly como exemplo), e então, dentro do DOSBox execute: <br /> 
```
mount c C:\Assembly 
C: 
cycles = 6000
boxshv.com 
```

## Controles
```
A - Move para a esquerda 
D - Move para a direita  
Spacebar - Atira    
Esc - Sai do jogo   
```

## Desenvolvimento
Esse projeto utilizou os seguintes recursos como referência: <br /> 
```
https://github.com/adamsmasher/sokobanDOS/tree/master (Tutorial de criação de jogos em assembly x86-16bits para o MSDos) 
https://github.com/pilotpirxie/assembler-apps/tree/main (Aplicações simples em assembly x86-16bits)
https://web.archive.org/web/20140702154140/http://www.brackeen.com/vga/index.html (Informações sobre o modo de vídeo VGA 256-Colors)
https://github.com/resetreboot/mineassembly (Implementação do jogo "Campo Minado" em assembly x86-16bits para o MSDos)
https://stackoverflow.com/questions/6560343/double-buffer-video-in-assembler (Implementação do Double Buffer)
```

Resolução da tela: 320x200 <br /> 

Palheta de cores para o int 13h: https://imgur.com/a/vga-256-color-chart-int13h-gMoQE5T <br /> 
Sprites Utilizados: <br />
```
https://ivoryred.itch.io/pico-8-character-sprite 
```


Para construir o arquivo boxshv, use o comando: <br /> 
```
nasm boxshv.asm -o boxshv.com
```

Para entrar em tela cheia no DOSBox, aperte Alt+Enter
