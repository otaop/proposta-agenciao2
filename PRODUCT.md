# Produto

<!-- impeccable:product-schema 1 -->

## Platform

web

## Users

O usuário principal é o responsável comercial da Agência O2, que precisa localizar, revisar e abrir rapidamente os orçamentos já produzidos para diferentes clientes.

Os destinatários das propostas continuam sendo os clientes da agência, mas não acessam o painel interno.

## Product Purpose

Centralizar o acesso aos orçamentos publicados pela Agência O2 sem transformar a página institucional da raiz em uma listagem. O painel deve permitir conferir o histórico, identificar cliente, projeto, data e status e abrir a proposta correspondente.

Sucesso significa encontrar qualquer orçamento produzido sem precisar lembrar sua pasta ou URL.

## Positioning

O painel é um índice operacional interno sobre o acervo de propostas da Agência O2. Ele organiza propostas que continuam sendo páginas independentes e compartilháveis com cada cliente.

## Operating Context

- As propostas são publicadas em `proposta.agenciao2.com.br/<cliente>/<projeto>/`.
- Os projetos mais recentes possuem `meta.json`; propostas legadas podem precisar de cadastro explícito.
- A raiz `/` permanece como página institucional e não lista orçamentos.
- A primeira versão do painel será acessada por um link reservado, sem login.
- Login e senha reais ficam como evolução futura.

## Capabilities and Constraints

- Rota prevista para o painel: `/painel/`.
- Listar somente propostas e orçamentos; relatórios de desempenho ficam fora.
- Reunir propostas atuais e legadas em um único lugar.
- Permitir busca textual e filtragem por cliente e status.
- Abrir cada proposta em sua URL existente.
- Manter compatibilidade com hospedagem estática em GitHub Pages.
- O link reservado não constitui controle de acesso seguro.
- Autenticação real, permissões por usuário e recuperação de senha estão explicitamente fora desta versão.

## Brand Commitments

- Preservar a identidade visual existente da Agência O2.
- Manter a página institucional da raiz sem alterações.
- Interface direta, objetiva e sem textos genéricos.

## Evidence on Hand

- Sistema visual e página institucional em `index.html`.
- Hubs existentes em `outplan/index.html` e `icfml/index.html`.
- Metadados em `*/<projeto>/meta.json`.
- Proposta legada em `dornelles-rodrigues/`.
- Gerador de hubs por cliente em `../build-hub.ps1`.

Não há autenticação, banco de dados ou backend no repositório atual.

## Product Principles

1. Um único lugar para encontrar todos os orçamentos.
2. Informação suficiente para reconhecer a proposta antes de abri-la.
3. O painel interno não altera nem expõe a navegação institucional pública.
4. Estados e filtros devem facilitar a operação, sem decorar a interface.
5. A ausência de login nesta versão deve ser comunicada com honestidade e não simulada por uma proteção frágil no navegador.
