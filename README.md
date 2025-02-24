# Projeto_AOC

## Introdução
Esse projeto busca implementar um shoot-em-up baseado em jogos como Space Invaders para o MSDos de 16 bits <br /> 

Para executar o programa, recomenda-se o uso do DOSBox, disponível em: https://www.dosbox.com/wiki/Releases

## Execução 
Mova os conteúdos desse repositório para C:\Assembly, e então, dentro do DOSBox execute: <br /> 
```
mount c C:\Assembly 
C: 
boxshv.com 
```

## Desenvolvimento
Esse projeto utilizou os seguintes recursos como referência: <br /> 
```
https://github.com/adamsmasher/sokobanDOS/tree/master (Tutorial de criação de jogos em assembly x86-16bits para o MSDos) 
https://github.com/pilotpirxie/assembler-apps/tree/main (Aplicações simples em assembly x86-16bits)
https://web.archive.org/web/20140702154140/http://www.brackeen.com/vga/index.html (Informações sobre o modo de vídeo VGA 256-Colors)
https://github.com/resetreboot/mineassembly (Implementação do jogo "Campo Minado" em assembly x86-16bits para o MSDos) 
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

A implementação do Back Buffer foi feita de acordo com o seguinte post do stack overflow:
```
https://stackoverflow.com/questions/6560343/double-buffer-video-in-assembler
```


Para entrar em tela cheia no DOSBox, aperte Alt+Enter