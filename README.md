<br>
<img src="https://drive.google.com/uc?export=view&id=1dSpQ1n429WG4rvsh-xKG7gkwGoVTySF1" width="1000">
<br>

# K8S Project

Oi, tudo bem? Se você chegou até aqui, é porque está interessado em saber mais sobre o diagrama que viu no LinkedIn, né? Então, vamos lá!

A proposta é realizar o deploy de uma aplicação web simples, desenvolvida em Python + Flask, para dentro de um Cluster Kubernetes na Digital Ocean - aproveitando o serviço gerenciado DOKS. Essa aplicação tem a função de retornar o nome do hostname para o qual a requisição web do cliente foi direcionada. No nosso contexto, esse será o hostname do pod que respondeu a essa requisição.

Cada requisição será encaminhada para um pod diferente graças ao serviço de load balancer do Cluster. Isso garante a distribuição equitativa das requisições, otimizando o aproveitamento dos recursos e evitando sobrecarregar um pod específico. Vamos explorar juntos essa dinâmica de distribuição eficiente!


## O ambiente utilizado (4)

Esse projeto foi realizado a partir do meu Host/PC, Linux Ubuntu 23.10 (Mantic Minotaur), com as seguintes ferramentas instaladas e configuradas conforme a necessidade.

Vou considerar que você possui um ambiente limpo, completamente limpo e listar como você deverá seguir. Não é obrigatório, mas tente seguir a mesma ordem:

#### 1. docker

Primeiro vamos instalar o 'docker', que será necessário para criarmos a imagem da aplicação e enviá-la para seu registry dentro da Digital Ocean.

Abra seu terminal e apenas aproveite o script para instalação simples:

    curl -fsSL https://get.docker.com -o get-docker.sh
    
Como pós-instalação, utilize o usermod para que seu usuário possa rodar os comandos do Docker:

    sudo usermod -aG docker $USER
    
**Você vai precisar logar novamente em seu Linux**. Quando retornar, teste com o comando:

    docker version

Isso deve trazer algumas informações do Docker, atestando nossa instalação.

E isso!
> Ref.: [Documentação do Docker](https://docs.docker.com/engine/install/ubuntu/)

#### 2. kubectl

Agora podemos instalar o 'kubectl', que será utilizado para efetuarmos manualmente o deployment da nossa aplicação web - que será a última etapa!

Ainda no seu terminal:

    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

Finalize com:

    sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

Teste a instalação com o comando:

`kubectl version --client`

Pronto! 
>Ref.: https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/#install-kubectl-binary-with-curl-on-linux

#### 3. terraform

Para nosso 'terraform', vamos seguir os passos em nosso terminal, primeiro:

    sudo apt update && sudo apt install -y gnupg software-properties-common

Agora vamos instalar a chave necessária:

    wget -O- https://apt.releases.hashicorp.com/gpg | \
    gpg --dearmor | \
    sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg

Adicione o repo oficial para download da ferramenta:

    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
    https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
    sudo tee /etc/apt/sources.list.d/hashicorp.list

E finalmente:

    sudo apt update
    sudo apt install terraform
   
Você pode verificar a instalação do 'terraform' com o comando:

    terraform --help

ou

    terraform -v

Foi!
>Ref.: https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli

#### 4. doctl

Talvez essa seja a ferramenta mais estranha aqui em nosso setup. Eu também conheci há pouco tempo, trata-se de uma CLI da própria Digital Ocean. Ela irá nos ajudar bastante em algumas etapas que precisam de autenticação e validações com o provider cloud. Vamos la:

    sudo snap install doctl

Sim, eles disponibilizam (oficialmente) a instalação apenas via snap. Então, certifique-se de ter o snap rodando em seu Ubuntu.

Teste com o comando:

    doctl version

Quero aproveitar o assunto 'Digital Ocean' e lembrar que você deve criar sua conta neste provider, caso ainda não possua. Após isso, acesse o menu API e crie para você um 'Personal Access Token'. Salve esse valor em um local seguro e jamais o compartilhe de qualquer forma.


