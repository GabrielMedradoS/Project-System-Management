# Project System Management

<p align='center'>
<b height="50%" width="50%"></b>
</p>

<p align="center">
    <img alt="Platform" src="https://img.shields.io/static/v1?label=Platform&message=Salesforce&color=0369a1&labelColor=f0f9ff">
    <img alt="project name" src="https://img.shields.io/badge/Project-System-Management-0369a1?&labelColor=f0f9ff"></img>    
    <img alt="Repository size" src="https://img.shields.io/github/repo-size/GabrielMedradoS/Project-System-Management?color=0369a1&labelColor=f0f9ff">
    <img alt="GitHub Last Commit" src="https://img.shields.io/github/last-commit/gabrielmedrados/Project-System-Management?&color=0369a1&labelColor=f0f9ff">    
    <a href="">
        <img alt="License" src="https://img.shields.io/static/v1?label=License&message=MIT&color=0369a1&labelColor=f0f9ff">
    </a>
</p>

<p align="center">
    <a href="#-objetivo">Objetivo</a> &nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;
    <a href="#-features">Features</a> &nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;
    <a href="#-demonstração">Demonstração</a> &nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;
    <a href="#-tecnologias">Tecnologias</a> &nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;
    <a href="#-documentação">Documentação</a> &nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;
    <a href="LICENSE">License</a> &nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;
    <a href="#-autor">Autor</a> 
</p>

## 📷 Layout

#### Screenshot:

<div align='center'>
🚧 Under construction 🚧
</div>

## 🎯 Objetivo

<div align="justify">
    (Learning Management System) <br>
    O objetivo é criar uma plataforma interativa de criação de cursos disponibilizado por professores
    onde os alunos poderão acessar o curso de seu interesse e aprender diretamente do site com video aulas disponibilizados pelo professor criador do curso e seus administradores.
    A ideia é facilitar o aprendizado à distância criando um software robusto e de fácil acesso/aprendizado, com uma metodologia didática e diversos cursos de treinamento tanto para o professor quanto para o aluno
</div>

## ✨ Features

- [] criação de cursos imediata

## 💻 Demonstração:

<div align='center'>
🚧 Under construction 🚧
</div>

## 🚴🏻‍♂️ Rodar o projeto

Para baixar o código-fonte do projeto em sua máquina, primeiramente terá que ter instalado o [**Git**](https://git-scm.com/).
Com o Git instalado, em seu terminal execute o seguinte comando:

```bash
git clone https://github.com/GabrielMedradoS/Project-System-Management.git
```

Para instalar as dependências e executar o projeto terá que ter instalado em sua máquina o [**node.js**](https://nodejs.org/en/), que vem acompanhado do npm.

Instale as dependências usando **npm**:

```bash
# pnpm
pnpm install
```

```bash
# npm
npm install
```

Execute o projeto:

```bash
# npm
npm run dev
```

O servidor estará disponível em http://localhost:3000.

## 🛠 Tecnologias

![My Skills](https://skillicons.dev/icons?i=ts,react,nodejs,tailwind)

## 📜 Documentação

#### 👇 Clique para ver as Dependências do projeto

<details>
    <summary>Dependencies</summary>

```json
{
  "name": "salesforce-app",
  "private": true,
  "version": "1.0.0",
  "description": "Project System Management",
  "scripts": {
    "lint": "eslint **/{aura,lwc}/**/*.js",
    "test": "npm run test:unit",
    "test:unit": "sfdx-lwc-jest",
    "test:unit:watch": "sfdx-lwc-jest --watch",
    "test:unit:debug": "sfdx-lwc-jest --debug",
    "test:unit:coverage": "sfdx-lwc-jest --coverage",
    "prettier": "prettier --write \"**/*.{cls,cmp,component,css,html,js,json,md,page,trigger,xml,yaml,yml}\"",
    "prettier:verify": "prettier --check \"**/*.{cls,cmp,component,css,html,js,json,md,page,trigger,xml,yaml,yml}\"",
    "postinstall": "husky init",
    "precommit": "lint-staged",
    "prepare": "husky"
  },
  "devDependencies": {
    "@lwc/eslint-plugin-lwc": "^2.2.0",
    "@lwc/engine-dom": "^8.18.0",
    "@lwc/jest-preset": "^19.1.0",
    "@prettier/plugin-xml": "^3.4.1",
    "@salesforce/eslint-config-lwc": "^3.7.2",
    "@salesforce/eslint-plugin-aura": "^2.1.0",
    "@salesforce/eslint-plugin-lightning": "^1.0.0",
    "@salesforce/sfdx-lwc-jest": "^7.0.1",
    "eslint": "^8.57.0",
    "eslint-plugin-import": "^2.31.0",
    "eslint-plugin-jest": "^28.11.0",
    "husky": "^9.1.7",
    "jest": "^29.7.0",
    "lint-staged": "^15.5.1",
    "prettier": "^3.5.3",
    "prettier-plugin-apex": "^2.2.6"
  },
  "lint-staged": {
    "**/*.{cls,cmp,component,css,html,js,json,md,page,trigger,xml,yaml,yml}": [
      "prettier --write"
    ],
    "**/{aura,lwc}/**/*.js": ["eslint"]
  }
}
```

</details>

- [Next.js 13 | documentation](https://nextjs.org/docs)
- [shadcn/ui | documentation](https://ui.shadcn.com/)

## 💡 Como contribuir

- Faça um **_fork_** desse repositório;
- Crie um **branch** para a sua feature: `git checkout -b minha-feature`;
- Faça um **commit** com suas alterações: `git commit -m 'feat: Minha nova feature'`;
- Faça um **push** para o seu branch: `git push origin minha-feature`;
- Faça um **pull request** com sua feature;

Pull requests são sempre bem-vindos. Em caso de dúvidas ou sugestões, crie uma _**issue**_ ou entre em contato comigo.

## ⚖️ License

This project is under the MIT license. See the archive [LICENSE]() for more details.

## ✍🏾 Autor

| <a href="https://github.com/gabrielmedrados/"><img src="https://user-images.githubusercontent.com/73303001/126536001-655e3cbd-facd-4de1-992f-b8d9d3656ace.jpg" width="100" alt="perfil"/><br>
| :-------------------------: |
| <a href="https://github.com/gabrielmedrados/"> Gabriel Medrado |</a> |

[![Linkedin Badge](https://img.shields.io/badge/-GabrielMedrado-blue?style=flat-square&logo=Linkedin&logoColor=white)](https://www.linkedin.com/in/gabriel-medrado-de-souza-9a30b3206/)
[![Gmail Badge](https://img.shields.io/badge/-gabriel.medradoo@hotmail.com-1769ff?style=flat-square&logo=Gmail&logoColor=white)](mailto:gabriel.medradoo@hotmail.com)
