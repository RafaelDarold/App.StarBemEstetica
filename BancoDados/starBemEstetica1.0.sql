CREATE DATABASE IF NOT EXISTS starBemEstetica;
USE starBemEstetica;

-- ENDERECO
CREATE TABLE Endereco (
    id_endereco INT AUTO_INCREMENT PRIMARY KEY,
    cep VARCHAR(8),
    rua VARCHAR(100),
    numero VARCHAR(10),
    bairro VARCHAR(100),
    cidade VARCHAR(100),
    estado VARCHAR(2),
    pais VARCHAR(50)
);

-- CLIENTES
CREATE TABLE Clientes (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100),
    sobrenome VARCHAR(100),
    cpf VARCHAR(14) UNIQUE,
    dataNasc DATE,
    email VARCHAR(100),
    sexo VARCHAR(1),
    telefone VARCHAR(13),
    id_endereco_fk INT NOT NULL,
    FOREIGN KEY (id_endereco_fk) REFERENCES Endereco(id_endereco)
);

-- TIPOUSUARIO
CREATE TABLE TipoUsuario (
    id_tipoUsuario INT AUTO_INCREMENT PRIMARY KEY,
    nivelAcesso VARCHAR(50),
    nome VARCHAR(100)
);

-- USUARIOS
CREATE TABLE Usuarios (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100),
    email VARCHAR(100),
    senha VARCHAR(100),
    id_tipoUsuario_fk INT NOT NULL,
    FOREIGN KEY (id_tipoUsuario_fk) REFERENCES TipoUsuario(id_tipoUsuario)
);

-- FUNCIONARIOS
CREATE TABLE Funcionarios (
    id_funcionario INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100),
    sobrenome VARCHAR(100),
    cpf VARCHAR(11) UNIQUE,
    dataNasc DATE,
    sexo VARCHAR(1),
    email VARCHAR(100),
    telefone VARCHAR(13),
    id_usuario_fk INT UNIQUE,
    id_endereco_fk INT NOT NULL,
    FOREIGN KEY (id_usuario_fk) REFERENCES Usuarios(id_usuario),
    FOREIGN KEY (id_endereco_fk) REFERENCES Endereco(id_endereco)
);

-- PRODUTOS / APARELHOS
CREATE TABLE ProdutosAparelhos (
    id_produtoAparelho INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100),
    categoria VARCHAR(100),
    descricaoUsabilidade TEXT,
    regiaoCorpoAtuacao VARCHAR(100),
    status VARCHAR(50)
);

-- SERVIÇOS
CREATE TABLE Servicos (
    id_servico INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100),
    regiaoCorpoAtuacao VARCHAR(100),
    descricao TEXT,
    duracaoMedia TIME,
    valorSugerido DOUBLE
);

-- TERCEIRA TABELA SERVICOS E PRODUTOS / APARELHOS
CREATE TABLE ProdutosAparelhos_Servicos (
	id_produtosAparelhos_servicos INT AUTO_INCREMENT PRIMARY KEY,
	id_produtoAparelho_fk INT NOT NULL,
    FOREIGN KEY (id_produtoAparelho_fk) REFERENCES ProdutosAparelhos(id_produtoAparelho),
    id_servico_fk INT NOT NULL,
    FOREIGN KEY (id_servico_fk) REFERENCES Servicos(id_servico)
);

-- FORNECEDORES
CREATE TABLE Fornecedores (
    id_fornecedor INT AUTO_INCREMENT PRIMARY KEY,
    cnpj VARCHAR(18) UNIQUE,
    razaoSocial VARCHAR(100),
    nomeFantasia VARCHAR(100),
    inscricaoEstadual VARCHAR(20),
    email VARCHAR(100),
    telefone VARCHAR(20),
    id_endereco_fk INT NOT NULL,
    FOREIGN KEY (id_endereco_fk) REFERENCES Endereco(id_endereco)
);

-- DESPESAS
CREATE TABLE Despesas (
    id_despesa INT AUTO_INCREMENT PRIMARY KEY,
    descricao TEXT,
    dataHora DATETIME,
    valor DOUBLE,
    formaPagamento VARCHAR(50),
    tipoDespesa VARCHAR(50),
    id_fornecedor_fk INT NOT NULL,
    FOREIGN KEY (id_fornecedor_fk) REFERENCES Fornecedores(id_fornecedor),
    id_funcionario_fk INT NOT NULL,
    FOREIGN KEY (id_funcionario_fk) REFERENCES Funcionarios(id_funcionario)
);

-- TERCEIRA TABELA DESPESAS E PRODUTOS / APARELHOS
CREATE TABLE Despesas_ProdutosAparelhos (
	id_despesas_produtosAparelhos INT AUTO_INCREMENT PRIMARY KEY,
    valorUnitario DOUBLE,
    quantidade DOUBLE,
    id_produtoAparelho_fk INT NOT NULL,
    FOREIGN KEY (id_produtoAparelho_fk) REFERENCES ProdutosAparelhos(id_produtoAparelho),
    id_despesa_fk INT NOT NULL,
    FOREIGN KEY (id_despesa_fk) REFERENCES Despesas(id_despesa)
);

-- CAIXAS
CREATE TABLE Caixas (
    id_caixa INT AUTO_INCREMENT PRIMARY KEY,
    dataHoraAbertura DATETIME,
    dataHoraEncerramento DATETIME,
    saldoInicio DOUBLE,
    saldoFinal DOUBLE
);

-- AGENDAMENTOS
CREATE TABLE Agendamentos (
    id_agendamento INT AUTO_INCREMENT PRIMARY KEY,
    dataHoraInicio DATETIME,
    dataHoraFinal DATETIME,
    observacao TEXT,
    status VARCHAR(50),
    valor DOUBLE,
    id_cliente_fk INT NOT NULL,
    id_funcionario_fk INT NOT NULL,
    FOREIGN KEY (id_cliente_fk) REFERENCES Clientes(id_cliente),
    FOREIGN KEY (id_funcionario_fk) REFERENCES Funcionarios(id_funcionario)
);

-- TERCEIRA TABELA AGENDAMENTOS E SERVICOS
CREATE TABLE Agendamentos_servicos (
	id_agendamentos_sevicos INT AUTO_INCREMENT PRIMARY KEY,
    valor DOUBLE,
    id_agendamento_fk INT NOT NULL,
    FOREIGN KEY(id_agendamento_fk) REFERENCES Agendamentos(id_agendamento),
    id_servico_fk INT NOT NULL,
    FOREIGN KEY(id_servico_fk) REFERENCES Servicos(id_servico)
);

-- ATENDIMENTOS
CREATE TABLE Atendimentos (
    id_atendimento INT AUTO_INCREMENT PRIMARY KEY,
    dataHoraInicial DATETIME,
    dataHoraFinal DATETIME,
    observacao TEXT,
    status VARCHAR(50),
    duracao TIME,
    valorTotal DOUBLE,
    formaPagamento VARCHAR(50),
    id_agendamento_fk INT NOT NULL UNIQUE,
    FOREIGN KEY (id_agendamento_fk) REFERENCES Agendamentos(id_agendamento),
    id_funcionario_fk INT NOT NULL,
    FOREIGN KEY (id_funcionario_fk) REFERENCES Funcionarios(id_funcionario)
);

-- TERCEIRA TABELA ATENDIMENTOS E SERVICOS
CREATE TABLE Atendimentos_servicos (
	id_atendimentos_servicos INT AUTO_INCREMENT PRIMARY KEY,
    valor DOUBLE,
    id_atendimento_fk INT NOT NULL,
    FOREIGN KEY(id_atendimento_fk) REFERENCES Atendimentos(id_atendimento),
    id_servico_fk INT NOT NULL,
    FOREIGN KEY(id_servico_fk) REFERENCES Servicos(id_servico)
);

-- RECEBIMENTOS
CREATE TABLE Recebimentos (
    id_recebimento INT AUTO_INCREMENT PRIMARY KEY,
    valor DOUBLE,
    tipoPagamento VARCHAR(50),
    parcela INT,
    dataHora DATETIME,
    status VARCHAR(50),
    percentualDesconto DOUBLE,
    id_atendimento_fk INT NOT NULL,
    FOREIGN KEY(id_atendimento_fk) REFERENCES Atendimentos(id_atendimento),
    id_caixa_fk INT NOT NULL,
    FOREIGN KEY (id_caixa_fk) REFERENCES Caixas(id_caixa)
);

-- COMISSAO
CREATE TABLE Comissao (
	id_comissao INT AUTO_INCREMENT PRIMARY KEY,
    percentual DOUBLE,
    valorTotal DOUBLE,
    status VARCHAR(100),
    observacao TEXT,
    dataHora DATETIME,
    id_atendimento_fk INT NOT NULL UNIQUE,
    FOREIGN KEY(id_atendimento_fk) REFERENCES Atendimentos(id_atendimento),
	id_funcionario_fk INT NOT NULL,
    FOREIGN KEY (id_funcionario_fk) REFERENCES Funcionarios(id_funcionario)
);

-- PAGAMENTOS
CREATE TABLE Pagamentos (
    id_pagamento INT AUTO_INCREMENT PRIMARY KEY,
    valor DOUBLE,
    tipoPagamento VARCHAR(50),
    parcela INT,
    dataHora DATETIME,
    status VARCHAR(50),
    id_despesa_fk INT,
    FOREIGN KEY (id_despesa_fk) REFERENCES Despesas(id_despesa),
    id_caixa_fk INT NOT NULL,
    FOREIGN KEY (id_caixa_fk) REFERENCES Caixas(id_caixa),
    id_comissao_fk INT UNIQUE,
    FOREIGN KEY (id_comissao_fk) REFERENCES Comissao(id_comissao)
);

INSERT INTO Endereco (cep, rua, numero, bairro, cidade, estado, pais) VALUES
('01234000', 'Rua das Flores', '100', 'Centro', 'São Paulo', 'SP', 'Brasil'),
('04567000', 'Avenida Paulista', '2000', 'Bela Vista', 'São Paulo', 'SP', 'Brasil'),
('03089000', 'Rua Augusta', '300', 'Consolação', 'São Paulo', 'SP', 'Brasil'),
('08090000', 'Rua da Paz', '400', 'Santo Amaro', 'São Paulo', 'SP', 'Brasil'),
('09012000', 'Alameda Santos', '500', 'Jardins', 'São Paulo', 'SP', 'Brasil'),
('05678000', 'Rua Oscar Freire', '600', 'Cerqueira César', 'São Paulo', 'SP', 'Brasil'),
('07890000', 'Avenida Brigadeiro Faria Lima', '700', 'Pinheiros', 'São Paulo', 'SP', 'Brasil'),
('03456000', 'Rua Haddock Lobo', '800', 'Cerqueira César', 'São Paulo', 'SP', 'Brasil'),
('06789000', 'Rua Pamplona', '900', 'Jardim Paulista', 'São Paulo', 'SP', 'Brasil'),
('02345000', 'Alameda Jaú', '1000', 'Jardim Paulista', 'São Paulo', 'SP', 'Brasil'),
('01153000', 'Rua Vergueiro', '1500', 'Liberdade', 'São Paulo', 'SP', 'Brasil'),
('01310940', 'Avenida Angélica', '250', 'Bela Vista', 'São Paulo', 'SP', 'Brasil'),
('01414001', 'Rua Bela Cintra', '1000', 'Jardim Paulista', 'São Paulo', 'SP', 'Brasil'),
('01502001', 'Rua da Consolação', '200', 'Consolação', 'São Paulo', 'SP', 'Brasil'),
('02012000', 'Rua Tutoia', '300', 'Paraíso', 'São Paulo', 'SP', 'Brasil'),
('03047000', 'Avenida do Estado', '400', 'Centro', 'São Paulo', 'SP', 'Brasil'),
('04007030', 'Rua Domingos de Morais', '500', 'Vila Mariana', 'São Paulo', 'SP', 'Brasil'),
('05010000', 'Rua Turiassu', '600', 'Perdizes', 'São Paulo', 'SP', 'Brasil'),
('05407000', 'Rua Teodoro Sampaio', '700', 'Pinheiros', 'São Paulo', 'SP', 'Brasil'),
('05508000', 'Avenida Francisco Matarazzo', '800', 'Água Branca', 'São Paulo', 'SP', 'Brasil'),
('05618000', 'Avenida República do Líbano', '900', 'Itaim Bibi', 'São Paulo', 'SP', 'Brasil'),
('05724000', 'Rua Desembargador do Vale', '100', 'Pirituba', 'São Paulo', 'SP', 'Brasil'),
('05801000', 'Avenida Inajar de Souza', '110', 'Casa Verde', 'São Paulo', 'SP', 'Brasil'),
('05904000', 'Rua José Jannarelli', '120', 'Freguesia do Ó', 'São Paulo', 'SP', 'Brasil'),
('06010000', 'Avenida Raimundo Pereira de Magalhães', '130', 'Pirituba', 'São Paulo', 'SP', 'Brasil'),
('06140000', 'Rua José Bonifácio', '140', 'Santana', 'São Paulo', 'SP', 'Brasil'),
('06230000', 'Avenida Luiz Dumont Villares', '150', 'Casa Verde', 'São Paulo', 'SP', 'Brasil'),
('06310000', 'Rua Voluntários da Pátria', '160', 'Santana', 'São Paulo', 'SP', 'Brasil'),
('06410000', 'Avenida Brigadeiro Faria Lima', '170', 'Pinheiros', 'São Paulo', 'SP', 'Brasil'),
('06502000', 'Rua Butantã', '180', 'Pinheiros', 'São Paulo', 'SP', 'Brasil');

INSERT INTO Clientes (nome, sobrenome, cpf, dataNasc, email, sexo, telefone, id_endereco_fk) VALUES
('Ana', 'Silva', '11122233344', '1985-05-15', 'ana.silva@email.com', 'F', '11987654321', 1),
('Carlos', 'Oliveira', '22233344455', '1990-08-20', 'carlos.oliveira@email.com', 'M', '11976543210', 2),
('Mariana', 'Santos', '33344455566', '1988-03-25', 'mariana.santos@email.com', 'F', '11965432109', 3),
('Pedro', 'Almeida', '44455566677', '1992-11-10', 'pedro.almeida@email.com', 'M', '11954321098', 4),
('Juliana', 'Costa', '55566677788', '1987-07-30', 'juliana.costa@email.com', 'F', '11943210987', 5),
('Ricardo', 'Pereira', '66677788899', '1995-02-18', 'ricardo.pereira@email.com', 'M', '11932109876', 6),
('Fernanda', 'Lima', '77788899900', '1983-09-05', 'fernanda.lima@email.com', 'F', '11921098765', 7),
('Lucas', 'Martins', '88899900011', '1991-12-22', 'lucas.martins@email.com', 'M', '11910987654', 8),
('Patricia', 'Rocha', '99900011122', '1989-04-15', 'patricia.rocha@email.com', 'F', '11909876543', 9),
('Roberto', 'Barbosa', '00011122233', '1980-06-28', 'roberto.barbosa@email.com', 'M', '11998765432', 10),
('Amanda', 'Ribeiro', '11122233355', '1990-04-12', 'amanda.ribeiro@email.com', 'F', '11987654322', 11),
('Bruno', 'Martins', '22233344466', '1988-07-23', 'bruno.martins@email.com', 'M', '11976543211', 12),
('Camila', 'Alves', '33344455577', '1992-11-30', 'camila.alves@email.com', 'F', '11965432100', 13),
('Daniel', 'Costa', '44455566688', '1985-02-15', 'daniel.costa@email.com', 'M', '11954321099', 14),
('Elaine', 'Souza', '55566677799', '1995-05-20', 'elaine.souza@email.com', 'F', '11943210988', 15),
('Fábio', 'Lima', '66677788800', '1983-09-10', 'fabio.lima@email.com', 'M', '11932109877', 16),
('Gabriela', 'Oliveira', '77788899911', '1991-12-05', 'gabriela.oliveira@email.com', 'F', '11921098766', 17),
('Henrique', 'Silva', '88899900022', '1987-08-18', 'henrique.silva@email.com', 'M', '11910987655', 18),
('Isabela', 'Santos', '99900011133', '1993-03-25', 'isabela.santos@email.com', 'F', '11909876544', 19),
('João', 'Pereira', '00011122244', '1980-06-08', 'joao.pereira@email.com', 'M', '11998765433', 20),
('Karina', 'Fernandes', '11122233366', '1989-01-17', 'karina.fernandes@email.com', 'F', '11987654344', 21),
('Leonardo', 'Gomes', '22233344477', '1994-10-22', 'leonardo.gomes@email.com', 'M', '11976543233', 22),
('Mariana', 'Rodrigues', '33344455588', '1986-07-14', 'mariana.rodrigues@email.com', 'F', '11965432222', 23),
('Nelson', 'Barbosa', '44455566699', '1997-04-03', 'nelson.barbosa@email.com', 'M', '11954321111', 24),
('Olivia', 'Carvalho', '55566677700', '1984-12-19', 'olivia.carvalho@email.com', 'F', '11943210000', 25),
('Paulo', 'Mendes', '66677788811', '1996-09-27', 'paulo.mendes@email.com', 'M', '11932109999', 26),
('Queila', 'Nunes', '77788899922', '1982-02-08', 'queila.nunes@email.com', 'F', '11921098888', 27),
('Rafael', 'Xavier', '88899900033', '1998-05-15', 'rafael.xavier@email.com', 'M', '11910997777', 28),
('Sandra', 'Vieira', '99900011144', '1981-11-23', 'sandra.vieira@email.com', 'F', '11909896666', 29),
('Tiago', 'Zimmermann', '00011122255', '1999-08-07', 'tiago.zimmermann@email.com', 'M', '11998795555', 30);

INSERT INTO TipoUsuario (nivelAcesso, nome) VALUES
('Administrador', 'Administrador do Sistema'),
('Gerente', 'Gerente da Estética'),
('Recepcionista', 'Atendente da Recepção'),
('Esteticista', 'Profissional de Estética'),
('Dermatologista', 'Médico Dermatologista'),
('Cosmetologista', 'Profissional de Cosmetologia'),
('Massoterapeuta', 'Profissional de Massoterapia'),
('Depiladora', 'Profissional de Depilação'),
('Manicure', 'Profissional de Manicure'),
('Cabeleireiro', 'Profissional de Cabelereiro'),
('Supervisor', 'Supervisor de Estética'),
('Estagiário', 'Estagiário de Estética'),
('Gerente', 'Gerente Financeiro'),
('RH', 'Recursos Humanos'),
('TI', 'Tecnologia da Informação'),
('Marketing', 'Profissional de Marketing'),
('Coordenação', 'Coordenador de Estética'),
('Auxiliar', 'Auxiliar de Limpeza'),
('Segurança', 'Segurança Patrimonial'),
('Recepcionista', 'Recepcionista Sênior'),
('Esteticista', 'Esteticista Corporal'),
('Dermatologista', 'Dermatologista Sênior'),
('Massoterapeuta', 'Massoterapeuta Especialista'),
('Depiladora', 'Depiladora Sênior'),
('Manicure', 'Manicure e Pedicure'),
('Cabeleireiro', 'Cabeleireiro Master'),
('Consultor', 'Consultor de Beleza'),
('Treinador', 'Treinador de Equipe'),
('Desenvolvedor', 'Desenvolvedor de Sistemas'),
('Analista', 'Analista de Qualidade');

INSERT INTO Usuarios (nome, email, senha, id_tipoUsuario_fk) VALUES
('Admin', 'admin@starbem.com', 'senha123', 1),
('Gerente1', 'gerente@starbem.com', 'gerente123', 2),
('Atendente1', 'atendente@starbem.com', 'atendente123', 3),
('Esteticista1', 'esteticista1@starbem.com', 'estetica123', 4),
('Derma1', 'dermatologista@starbem.com', 'derma123', 5),
('Cosmeto1', 'cosmetologista@starbem.com', 'cosmeto123', 6),
('Massage1', 'massoterapeuta@starbem.com', 'massagem123', 7),
('Depiladora1', 'depiladora@starbem.com', 'depilacao123', 8),
('Manicure1', 'manicure@starbem.com', 'manicure123', 9),
('Cabeleireira1', 'cabeleireira@starbem.com', 'cabelo123', 10),
('Supervisor1', 'supervisor1@starbem.com', 'sup123', 11),
('Estagiario1', 'estagiario1@starbem.com', 'est123', 12),
('GerenteFin1', 'gerentefin1@starbem.com', 'fin123', 13),
('RH1', 'rh1@starbem.com', 'rh123', 14),
('TI1', 'ti1@starbem.com', 'ti123', 15),
('Marketing1', 'marketing1@starbem.com', 'mkt123', 16),
('Coordenador1', 'coordenador1@starbem.com', 'coord123', 17),
('Auxiliar1', 'auxiliar1@starbem.com', 'aux123', 18),
('Seguranca1', 'seguranca1@starbem.com', 'seg123', 19),
('Recepcionista2', 'recepcionista2@starbem.com', 'rec123', 20),
('Esteticista2', 'esteticista2@starbem.com', 'estet123', 21),
('Derma2', 'dermatologista2@starbem.com', 'derma123', 22),
('Massage2', 'massoterapeuta2@starbem.com', 'mass123', 23),
('Depiladora2', 'depiladora2@starbem.com', 'dep123', 24),
('Manicure2', 'manicure2@starbem.com', 'man123', 25),
('Cabeleireira2', 'cabeleireira2@starbem.com', 'cab123', 26),
('Consultor1', 'consultor1@starbem.com', 'cons123', 27),
('Treinador1', 'treinador1@starbem.com', 'trein123', 28),
('Dev1', 'dev1@starbem.com', 'dev123', 29),
('Analista1', 'analista1@starbem.com', 'ana123', 30);

INSERT INTO Funcionarios (nome, sobrenome, cpf, dataNasc, sexo, email, telefone, id_usuario_fk, id_endereco_fk) VALUES
('João', 'Silveira', '12345678901', '1980-01-10', 'M', 'joao.silveira@starbem.com', '11912345678', 1, 1),
('Maria', 'Fernandes', '23456789012', '1985-02-15', 'F', 'maria.fernandes@starbem.com', '11923456789', 2, 2),
('Carlos', 'Mendes', '34567890123', '1982-03-20', 'M', 'carlos.mendes@starbem.com', '11934567890', 3, 3),
('Ana', 'Carvalho', '45678901234', '1988-04-25', 'F', 'ana.carvalho@starbem.com', '11945678901', 4, 4),
('Paulo', 'Ribeiro', '56789012345', '1975-05-30', 'M', 'paulo.ribeiro@starbem.com', '11956789012', 5, 5),
('Fernanda', 'Gomes', '67890123456', '1990-06-05', 'F', 'fernanda.gomes@starbem.com', '11967890123', 6, 6),
('Ricardo', 'Nunes', '78901234567', '1987-07-12', 'M', 'ricardo.nunes@starbem.com', '11978901234', 7, 7),
('Patricia', 'Lopes', '89012345678', '1992-08-18', 'F', 'patricia.lopes@starbem.com', '11989012345', 8, 8),
('Marcos', 'Souza', '90123456789', '1983-09-22', 'M', 'marcos.souza@starbem.com', '11990123456', 9, 9),
('Juliana', 'Andrade', '01234567890', '1995-10-28', 'F', 'juliana.andrade@starbem.com', '11901234567', 10, 10),
('Supervisor', 'Silva', '12345678911', '1985-03-15', 'M', 'supervisor.silva@starbem.com', '11912345688', 11, 11),
('Estagiário', 'Santos', '23456789022', '1998-05-20', 'M', 'estagiario.santos@starbem.com', '11923456799', 12, 12),
('Gerente', 'Financeiro', '34567890133', '1980-07-25', 'M', 'gerente.financeiro@starbem.com', '11934567800', 13, 13),
('Recursos', 'Humanos', '45678901244', '1982-09-10', 'F', 'rh@starbem.com', '11945678911', 14, 14),
('TI', 'Suporte', '56789012355', '1987-11-30', 'M', 'ti@starbem.com', '11956789022', 15, 15),
('Marketing', 'Digital', '67890123466', '1990-01-12', 'F', 'marketing@starbem.com', '11967890133', 16, 16),
('Coordenador', 'Estética', '78901234577', '1983-04-05', 'F', 'coordenador@starbem.com', '11978901244', 17, 17),
('Auxiliar', 'Limpeza', '89012345688', '1995-06-18', 'F', 'auxiliar@starbem.com', '11989012355', 18, 18),
('Segurança', 'Patrimonial', '90123456799', '1988-08-22', 'M', 'seguranca@starbem.com', '11990123466', 19, 19),
('Recepcionista', 'Sênior', '01234567800', '1992-10-15', 'F', 'recepcionista2@starbem.com', '11901234577', 20, 20),
('Esteticista', 'Corporal', '12345678922', '1986-12-28', 'F', 'esteticista2@starbem.com', '11912345699', 21, 21),
('Dermatologista', 'Sênior', '23456789033', '1979-02-14', 'F', 'dermatologista2@starbem.com', '11923456700', 22, 22),
('Massoterapeuta', 'Especialista', '34567890144', '1984-05-07', 'M', 'massoterapeuta2@starbem.com', '11934567811', 23, 23),
('Depiladora', 'Sênior', '45678901255', '1991-07-19', 'F', 'depiladora2@starbem.com', '11945678922', 24, 24),
('Manicure', 'Pedicure', '56789012366', '1993-09-03', 'F', 'manicure2@starbem.com', '11956789033', 25, 25),
('Cabeleireiro', 'Master', '67890123477', '1981-11-11', 'M', 'cabeleireiro2@starbem.com', '11967890144', 26, 26),
('Consultor', 'Beleza', '78901234588', '1989-01-25', 'M', 'consultor@starbem.com', '11978901255', 27, 27),
('Treinador', 'Equipe', '89012345699', '1980-03-08', 'M', 'treinador@starbem.com', '11989012366', 28, 28),
('Desenvolvedor', 'Sistemas', '90123456700', '1994-04-17', 'M', 'dev@starbem.com', '11990123477', 29, 29),
('Analista', 'Qualidade', '01234567811', '1987-06-29', 'F', 'analista@starbem.com', '11901234588', 30, 30);

INSERT INTO ProdutosAparelhos (nome, categoria, descricaoUsabilidade, regiaoCorpoAtuacao, status) VALUES
('Aparelho de Radiofrequência', 'aparelho', 'Estimula colágeno e trata flacidez', 'Rosto e corpo', 'Ativo'),
('Ultrassom Microfocado', 'aparelho', 'Tratamento para lifting não invasivo', 'Rosto e pescoço', 'Ativo'),
('Laser de Diodo', 'aparelho', 'Remoção de pelos definitiva', 'Corpo inteiro', 'Ativo'),
('aparelho Criolipólise', 'aparelho', 'Redução de gordura localizada', 'Abdômen e flancos', 'Em manutenção'),
('Carboxiterapia', 'produto', 'Tratamento para celulite e estrias', 'Coxas e glúteos', 'Ativo'),
('Dermaroller', 'produto', 'Microagulhamento para rejuvenescimento', 'Rosto', 'Ativo'),
('aparelho IPL', 'aparelho', 'Luz pulsada para manchas e vasinhos', 'Rosto e colo', 'Ativo'),
('Endermologia', 'aparelho', 'Massagem para redução de celulite', 'Coxas e glúteos', 'Ativo'),
('Peeling de Diamante', 'produto', 'Esfoliação profunda para pele', 'Rosto', 'Ativo'),
('Ozonioterapia', 'aparelho', 'Tratamento para rejuvenescimento', 'Rosto e corpo', 'Inativo'),
('Microagulhamento Automático', 'aparelho', 'Estimulação profunda da pele', 'Rosto', 'Ativo'),
('Hidrafacial', 'aparelho', 'Limpeza e hidratação profunda', 'Rosto', 'Ativo'),
('Laser CO2 Fracionado', 'aparelho', 'Tratamento para cicatrizes e rugas', 'Rosto', 'Ativo'),
('Ultrassom Terapêutico', 'aparelho', 'Redução de inflamações', 'Corpo inteiro', 'Ativo'),
('Corrente Russa', 'aparelho', 'Estimulação muscular', 'Glúteos e abdômen', 'Ativo'),
('Ácido Hialurônico', 'produto', 'Preenchimento facial', 'Rosto', 'Ativo'),
('Toxina Botulínica', 'produto', 'Tratamento de rugas', 'Rosto', 'Ativo'),
('Vitamina C', 'produto', 'Clareamento e proteção', 'Rosto', 'Ativo'),
('Ácido Salicílico', 'produto', 'Esfoliação química', 'Rosto', 'Ativo'),
('Argila Verde', 'produto', 'Limpeza profunda', 'Rosto e corpo', 'Ativo'),
('Máscara de Ouro', 'produto', 'Rejuvenescimento', 'Rosto', 'Ativo'),
('Creme de Ureia', 'produto', 'Hidratação intensa', 'Corpo inteiro', 'Ativo'),
('Óleo de Rosa Mosqueta', 'produto', 'Tratamento de estrias', 'Corpo inteiro', 'Ativo'),
('Protetor Solar FPS 60', 'produto', 'Proteção UVA/UVB', 'Rosto e corpo', 'Ativo'),
('Ácido Glicólico', 'produto', 'Renovação celular', 'Rosto', 'Ativo'),
('Ácido Mandélico', 'produto', 'Esfoliação suave', 'Rosto', 'Ativo'),
('Peeling de Cristal', 'produto', 'Esfoliação mecânica', 'Rosto', 'Ativo'),
('Máscara de Colágeno', 'produto', 'Firmeza da pele', 'Rosto', 'Ativo'),
('Gel de Aloe Vera', 'produto', 'Hidratação e cicatrização', 'Corpo inteiro', 'Ativo'),
('Creme de Silicone', 'produto', 'Tratamento de cicatrizes', 'Corpo inteiro', 'Ativo');

INSERT INTO Servicos (nome, regiaoCorpoAtuacao, descricao, duracaoMedia, valorSugerido) VALUES
('Limpeza de Pele', 'Rosto', 'Limpeza profunda com extração de cravos', '01:00:00', 150.00),
('Massagem Relaxante', 'Costas e pescoço', 'Massagem para alívio de tensão', '00:50:00', 120.00),
('Depilação a Laser', 'Axilas', 'Remoção definitiva de pelos', '00:30:00', 200.00),
('Tratamento para Celulite', 'Coxas e glúteos', 'Redução de celulite com massagem', '01:15:00', 180.00),
('Botox', 'Rosto', 'Aplicação de toxina botulínica', '00:45:00', 500.00),
('Preenchimento Labial', 'Lábios', 'Aumento de volume com ácido hialurônico', '01:00:00', 600.00),
('Drenagem Linfática', 'Corpo inteiro', 'Massagem para redução de inchaço', '01:00:00', 160.00),
('Design de Sobrancelhas', 'Sobrancelhas', 'Design e henna', '00:30:00', 80.00),
('Manicure e Pedicure', 'Mãos e pés', 'Cuidados com unhas e cutículas', '01:30:00', 100.00),
('Hidratação Capilar', 'Cabelos', 'Tratamento intensivo para cabelos', '01:15:00', 150.00),
('Microagulhamento', 'Rosto', 'Estimulação de colágeno com microagulhas', '01:30:00', 350.00),
('Hidrafacial', 'Rosto', 'Limpeza profunda com hidratação', '01:00:00', 280.00),
('Laser CO2', 'Rosto', 'Tratamento para rugas e cicatrizes', '01:15:00', 1200.00),
('Ultrassom Terapêutico', 'Corpo inteiro', 'Redução de inflamações e dores', '00:45:00', 180.00),
('Corrente Russa', 'Glúteos', 'Estimulação muscular para hipertrofia', '00:30:00', 150.00),
('Preenchimento Facial', 'Rosto', 'Aplicação de ácido hialurônico', '01:00:00', 800.00),
('Aplicação de Botox', 'Rosto', 'Redução de rugas de expressão', '00:45:00', 600.00),
('Peeling Químico', 'Rosto', 'Renovação celular com ácidos', '01:00:00', 300.00),
('Tratamento Capilar', 'Cabelos', 'Hidratação e reconstrução', '01:30:00', 200.00),
('Drenagem Pós-Operatória', 'Corpo inteiro', 'Redução de inchaço após cirurgias', '01:00:00', 220.00),
('Massagem Modeladora', 'Abdômen', 'Redução de medidas e celulite', '01:00:00', 180.00),
('Limpeza de Pele Profunda', 'Rosto', 'Limpeza com extração completa', '01:30:00', 250.00),
('Depilação a Laser', 'Axilas', 'Remoção definitiva de pelos', '00:30:00', 200.00),
('Design de Sobrancelhas', 'Sobrancelhas', 'Design com henna', '00:30:00', 80.00),
('Manicure', 'Mãos', 'Cuidados com unhas e cutículas', '01:00:00', 70.00),
('Pedicure', 'Pés', 'Cuidados com unhas e cutículas', '01:00:00', 80.00),
('Bambuterapia', 'Corpo inteiro', 'Massagem com bambu', '01:00:00', 220.00),
('Ventosaterapia', 'Costas', 'Tratamento com ventosas', '00:45:00', 150.00),
('Radiofrequência', 'Rosto e corpo', 'Estímulo de colágeno', '01:00:00', 300.00),
('Criolipólise', 'Abdômen', 'Redução de gordura localizada', '01:00:00', 400.00);

INSERT INTO ProdutosAparelhos_Servicos (id_produtoAparelho_fk, id_servico_fk) VALUES
(1, 1), (2, 1), (3, 3), (4, 4), (5, 4),(6, 1), (7, 1), (8, 4), (9, 1), (10, 1),
(11, 11), (12, 12), (13, 13), (14, 14), (15, 15),(16, 16), (17, 17), (18, 18), 
(19, 19), (20, 20),(21, 11), (22, 12), (23, 13), (24, 14), (25, 15),(26, 16), 
(27, 17), (28, 18), (29, 19), (30, 20);

INSERT INTO Fornecedores (cnpj, razaoSocial, nomeFantasia, inscricaoEstadual, email, telefone, id_endereco_fk) VALUES
('12345678000101', 'Beleza Total Ltda', 'Beleza Total', '123456789', 'contato@belezatotal.com', '1123456789', 1),
('23456789000102', 'Estética Avançada S.A.', 'Estética Avançada', '234567890', 'vendas@esteticaavancada.com', '1123456790', 2),
('34567890000103', 'Cosméticos Premium Ltda', 'Cosméticos Premium', '345678901', 'sac@cosmeticospremium.com', '1123456791', 3),
('45678901000104', 'Equipamentos Estéticos S.A.', 'Equipamentos Estéticos', '456789012', 'vendas@equipamentosesteticos.com', '1123456792', 4),
('56789012000105', 'Produtos Naturais Ltda', 'Produtos Naturais', '567890123', 'contato@produtosnaturais.com', '1123456793', 5),
('67890123000106', 'Tecnologia em Beleza S.A.', 'Tecnobeleza', '678901234', 'sac@tecnobeleza.com', '1123456794', 6),
('78901234000107', 'Distribuidora de Cosméticos Ltda', 'Distribelza', '789012345', 'vendas@distribelza.com', '1123456795', 7),
('89012345000108', 'Importadora de Produtos S.A.', 'ImportBeleza', '890123456', 'contato@importbeleza.com', '1123456796', 8),
('90123456000109', 'Fábrica de Cosméticos Ltda', 'FábricaBeleza', '901234567', 'sac@fabricabeleza.com', '1123456797', 9),
('01234567000110', 'Atacado de Estética S.A.', 'AtacadoEstética', '012345678', 'vendas@atacadoestetica.com', '1123456798', 10),
('11222333000101', 'Beleza Total Importados Ltda', 'Beleza Import', '112223334', 'contato@belezaimport.com', '1123456780', 11),
('22333444000102', 'Estética Brasil S.A.', 'Estética Brasil', '223334445', 'vendas@esteticabrasil.com', '1123456781', 12),
('33444555000103', 'Cosméticos Premium Internacional Ltda', 'Cosméticos Premium Int', '334445556', 'sac@cosmeticospremiumint.com', '1123456782', 13),
('44555666000104', 'Equipamentos Dermatológicos S.A.', 'Derma Equip', '445556667', 'vendas@dermaequip.com', '1123456783', 14),
('55666777000105', 'Produtos Naturais do Brasil Ltda', 'Produtos Naturais BR', '556667778', 'contato@produtosnaturaisbr.com', '1123456784', 15),
('66777888000106', 'Tecnologia em Estética S.A.', 'TecnoEstética', '667778889', 'sac@tecnoestetica.com', '1123456785', 16),
('77888999000107', 'Distribuidora de Cosméticos Nacional Ltda', 'Distribelza Nacional', '778889990', 'vendas@distribelzanacional.com', '1123456786', 17),
('88999000000108', 'Importadora de Produtos Estéticos S.A.', 'ImportEstética', '889990001', 'contato@importestetica.com', '1123456787', 18),
('99000111000109', 'Fábrica de Cosméticos Avançados Ltda', 'FábricaCosmética', '990001112', 'sac@fabricacosmetica.com', '1123456788', 19),
('00111222000110', 'Atacado de Estética Nacional S.A.', 'AtacadoEstética Nacional', '001112223', 'vendas@atacadoesteticanacional.com', '1123456789', 20),
('11222333000111', 'Beleza e Saúde Ltda', 'Beleza Saúde', '112223335', 'contato@belezasaude.com', '1123456790', 21),
('22333444000112', 'Estética & Bem Estar S.A.', 'Estética Bem Estar', '223334446', 'vendas@esteticabemestar.com', '1123456791', 22),
('33444555000113', 'Cosméticos de Luxo Ltda', 'Cosméticos Luxo', '334445557', 'sac@cosmeticosluxo.com', '1123456792', 23),
('44555666000114', 'Equipamentos de Beleza S.A.', 'Beleza Equip', '445556668', 'vendas@belezaequip.com', '1123456793', 24),
('55666777000115', 'Produtos Orgânicos do Brasil Ltda', 'Produtos Orgânicos BR', '556667779', 'contato@produtosorganicosbr.com', '1123456794', 25),
('66777888000116', 'Tecnologia em Beleza Avançada S.A.', 'TecnoBeleza Avançada', '667778880', 'sac@tecnobelezaavancada.com', '1123456795', 26),
('77888999000117', 'Distribuidora de Produtos Estéticos Ltda', 'DistriEstética', '778889991', 'vendas@distriestetica.com', '1123456796', 27),
('88999000000118', 'Importadora de Equipamentos S.A.', 'ImportEquip', '889990002', 'contato@importequip.com', '1123456797', 28),
('99000111000119', 'Fábrica de Produtos Dermatológicos Ltda', 'FábricaDerma', '990001113', 'sac@fabricaderma.com', '1123456798', 29),
('00111222000120', 'Atacado de Cosméticos S.A.', 'AtacadoCosméticos', '001112224', 'vendas@atacadocosmeticos.com', '1123456799', 30);

INSERT INTO Despesas (descricao, dataHora, valor, formaPagamento, tipoDespesa, id_fornecedor_fk, id_funcionario_fk) VALUES
('Compra de cremes faciais', '2023-01-05 10:00:00', 1200.00, 'Cartão de Crédito', 'Produtos', 1, 1),
('Manutenção de aparelho', '2023-01-10 14:30:00', 800.00, 'Boleto', 'Manutenção', 2, 2),
('Pagamento de água', '2023-01-15 09:00:00', 150.00, 'Débito Automático', 'Conta', 3, 3),
('Compra de toalhas', '2023-01-20 11:15:00', 300.00, 'Dinheiro', 'Material', 4, 4),
('Pagamento de luz', '2023-01-25 08:45:00', 200.00, 'Débito Automático', 'Conta', 5, 5),
('Compra de produtos capilares', '2023-02-01 13:20:00', 950.00, 'Cartão de Crédito', 'Produtos', 6, 6),
('Manutenção preventiva', '2023-02-05 15:10:00', 600.00, 'Boleto', 'Manutenção', 7, 7),
('Compra de uniformes', '2023-02-10 10:30:00', 450.00, 'Dinheiro', 'Material', 8, 8),
('Pagamento de internet', '2023-02-15 09:15:00', 120.00, 'Débito Automático', 'Conta', 9, 9),
('Compra de acessórios', '2023-02-20 16:45:00', 250.00, 'Cartão de Débito', 'Material', 10, 10),
('Compra de ácido hialurônico', '2023-03-05 10:00:00', 2500.00, 'Cartão de Crédito', 'Produtos', 11, 11),
('Manutenção de laser CO2', '2023-03-10 14:30:00', 1200.00, 'Boleto', 'Manutenção', 12, 12),
('Pagamento de aluguel', '2023-03-15 09:00:00', 3500.00, 'Débito Automático', 'Conta', 13, 13),
('Compra de uniformes novos', '2023-03-20 11:15:00', 800.00, 'Dinheiro', 'Material', 14, 14),
('Pagamento de energia', '2023-03-25 08:45:00', 450.00, 'Débito Automático', 'Conta', 15, 15),
('Compra de produtos de limpeza', '2023-04-01 13:20:00', 350.00, 'Cartão de Crédito', 'Material', 16, 16),
('Manutenção preventiva equipamentos', '2023-04-05 15:10:00', 900.00, 'Boleto', 'Manutenção', 17, 17),
('Compra de toalhas descartáveis', '2023-04-10 10:30:00', 600.00, 'Dinheiro', 'Material', 18, 18),
('Pagamento de internet', '2023-04-15 09:15:00', 150.00, 'Débito Automático', 'Conta', 19, 19),
('Compra de luvas e máscaras', '2023-04-20 16:45:00', 300.00, 'Cartão de Débito', 'Material', 20, 20),
('Compra de toxina botulínica', '2023-05-05 10:00:00', 2800.00, 'Cartão de Crédito', 'Produtos', 21, 21),
('Manutenção de radiofrequência', '2023-05-10 14:30:00', 850.00, 'Boleto', 'Manutenção', 22, 22),
('Pagamento de água', '2023-05-15 09:00:00', 180.00, 'Débito Automático', 'Conta', 23, 23),
('Compra de lençóis descartáveis', '2023-05-20 11:15:00', 400.00, 'Dinheiro', 'Material', 24, 24),
('Pagamento de telefone', '2023-05-25 08:45:00', 220.00, 'Débito Automático', 'Conta', 25, 25),
('Compra de produtos capilares', '2023-06-01 13:20:00', 750.00, 'Cartão de Crédito', 'Produtos', 26, 26),
('Manutenção de ultrassom', '2023-06-05 15:10:00', 700.00, 'Boleto', 'Manutenção', 27, 27),
('Compra de aventais', '2023-06-10 10:30:00', 500.00, 'Dinheiro', 'Material', 28, 28),
('Pagamento de condomínio', '2023-06-15 09:15:00', 1200.00, 'Débito Automático', 'Conta', 29, 29),
('Compra de álcool em gel', '2023-06-20 16:45:00', 250.00, 'Cartão de Débito', 'Material', 30, 30);

INSERT INTO Despesas_ProdutosAparelhos (valorUnitario, quantidade, id_produtoAparelho_fk, id_despesa_fk) VALUES
(120.00, 10, 1, 1), (80.00, 1, 2, 2), (150.00, 1, 3, 3), (30.00, 10, 4, 4),
(20.00, 10, 5, 5), (95.00, 10, 6, 6), (60.00, 1, 7, 7), (45.00, 10, 8, 8),
(12.00, 10, 9, 9), (25.00, 10, 10, 10), (250.00, 10, 11, 11), (120.00, 1, 12, 12), 
(350.00, 1, 13, 13), (40.00, 20, 14, 14),(25.00, 32, 15, 15), (35.00, 10, 16, 16), 
(70.00, 1, 17, 17), (50.00, 12, 18, 18),(15.00, 20, 19, 19), (30.00, 10, 20, 20), 
(280.00, 10, 21, 21), (85.00, 1, 22, 22),(180.00, 1, 23, 23), (40.00, 10, 24, 24), 
(22.00, 10, 25, 25), (75.00, 10, 26, 26),(70.00, 1, 27, 27), (50.00, 10, 28, 28), 
(12.00, 20, 29, 29), (25.00, 10, 30, 30);

INSERT INTO Caixas (dataHoraAbertura, dataHoraEncerramento, saldoInicio, saldoFinal) VALUES
('2023-01-02 08:00:00', '2023-01-02 18:00:00', 500.00, 3200.00),
('2023-01-03 08:00:00', '2023-01-03 18:00:00', 500.00, 2800.00),
('2023-01-04 08:00:00', '2023-01-04 18:00:00', 500.00, 3500.00),
('2023-01-05 08:00:00', '2023-01-05 18:00:00', 500.00, 4100.00),
('2023-01-06 08:00:00', '2023-01-06 18:00:00', 500.00, 2900.00),
('2023-01-07 08:00:00', '2023-01-07 18:00:00', 500.00, 3800.00),
('2023-01-09 08:00:00', '2023-01-09 18:00:00', 500.00, 2700.00),
('2023-01-10 08:00:00', '2023-01-10 18:00:00', 500.00, 3300.00),
('2023-01-11 08:00:00', '2023-01-11 18:00:00', 500.00, 3600.00),
('2023-01-12 08:00:00', '2023-01-12 18:00:00', 500.00, 4200.00),
('2023-03-02 08:00:00', '2023-03-02 18:00:00', 500.00, 3800.00),
('2023-03-03 08:00:00', '2023-03-03 18:00:00', 500.00, 4200.00),
('2023-03-04 08:00:00', '2023-03-04 18:00:00', 500.00, 3500.00),
('2023-03-05 08:00:00', '2023-03-05 18:00:00', 500.00, 4800.00),
('2023-03-06 08:00:00', '2023-03-06 18:00:00', 500.00, 3200.00),
('2023-03-07 08:00:00', '2023-03-07 18:00:00', 500.00, 4100.00),
('2023-03-09 08:00:00', '2023-03-09 18:00:00', 500.00, 2900.00),
('2023-03-10 08:00:00', '2023-03-10 18:00:00', 500.00, 3700.00),
('2023-03-11 08:00:00', '2023-03-11 18:00:00', 500.00, 3900.00),
('2023-03-12 08:00:00', '2023-03-12 18:00:00', 500.00, 4500.00),
('2023-04-02 08:00:00', '2023-04-02 18:00:00', 500.00, 3600.00),
('2023-04-03 08:00:00', '2023-04-03 18:00:00', 500.00, 3100.00),
('2023-04-04 08:00:00', '2023-04-04 18:00:00', 500.00, 4000.00),
('2023-04-05 08:00:00', '2023-04-05 18:00:00', 500.00, 4700.00),
('2023-04-06 08:00:00', '2023-04-06 18:00:00', 500.00, 3300.00),
('2023-04-07 08:00:00', '2023-04-07 18:00:00', 500.00, 4200.00),
('2023-04-09 08:00:00', '2023-04-09 18:00:00', 500.00, 3000.00),
('2023-04-10 08:00:00', '2023-04-10 18:00:00', 500.00, 3800.00);

INSERT INTO Agendamentos (dataHoraInicio, dataHoraFinal, observacao, status, valor, id_cliente_fk, id_funcionario_fk) VALUES
('2023-01-02 09:00:00', '2023-01-02 10:00:00', 'Cliente preferencial', 'Concluído', 150.00, 1, 4),
('2023-01-02 10:30:00', '2023-01-02 11:20:00', 'Primeira sessão', 'Concluído', 120.00, 2, 5),
('2023-01-03 14:00:00', '2023-01-03 15:15:00', 'Alergia a amendoim', 'Concluído', 180.00, 3, 6),
('2023-01-04 11:00:00', '2023-01-04 11:45:00', 'Retorno após 6 meses', 'Concluído', 500.00, 4, 7),
('2023-01-05 16:00:00', '2023-01-05 17:00:00', 'Presente de aniversário', 'Concluído', 600.00, 5, 8),
('2023-01-06 13:00:00', '2023-01-06 14:00:00', 'Cliente nova', 'Concluído', 160.00, 6, 9),
('2023-01-07 15:30:00', '2023-01-07 16:00:00', 'Formatura no sábado', 'Concluído', 80.00, 7, 10),
('2023-01-09 10:00:00', '2023-01-09 11:30:00', 'Pacote de 5 sessões', 'Concluído', 100.00, 8, 4),
('2023-01-10 17:00:00', '2023-01-10 18:15:00', 'Cabelos muito ressecados', 'Concluído', 150.00, 9, 5),
('2023-01-11 09:30:00', '2023-01-11 10:30:00', 'Retorno mensal', 'Cancelado', 150.00, 10, 6),
('2023-03-02 09:00:00', '2023-03-02 10:30:00', 'Cliente VIP', 'Concluído', 350.00, 11, 11),
('2023-03-02 11:00:00', '2023-03-02 12:00:00', 'Primeira sessão', 'Concluído', 280.00, 12, 12),
('2023-03-03 14:00:00', '2023-03-03 15:15:00', 'Alergia a látex', 'Concluído', 1200.00, 13, 13),
('2023-03-04 10:00:00', '2023-03-04 11:00:00', 'Retorno trimestral', 'Concluído', 800.00, 14, 14),
('2023-03-05 16:00:00', '2023-03-05 17:00:00', 'Presente de aniversário', 'Concluído', 600.00, 15, 15),
('2023-03-06 13:00:00', '2023-03-06 14:30:00', 'Cliente nova', 'Concluído', 300.00, 16, 16),
('2023-03-07 15:30:00', '2023-03-07 16:15:00', 'Formatura', 'Concluído', 220.00, 17, 17),
('2023-03-09 10:00:00', '2023-03-09 11:30:00', 'Pacote de 3 sessões', 'Concluído', 180.00, 18, 18),
('2023-03-10 17:00:00', '2023-03-10 18:15:00', 'Cabelos danificados', 'Concluído', 250.00, 19, 19),
('2023-03-11 09:30:00', '2023-03-11 10:30:00', 'Retorno mensal', 'Cancelado', 200.00, 20, 20),
('2023-04-02 09:00:00', '2023-04-02 10:30:00', 'Cliente preferencial', 'Concluído', 350.00, 21, 21),
('2023-04-03 11:00:00', '2023-04-03 12:00:00', 'Primeira aplicação', 'Concluído', 280.00, 22, 22),
('2023-04-04 14:00:00', '2023-04-04 15:15:00', 'Sensibilidade na pele', 'Concluído', 1200.00, 23, 23),
('2023-04-05 10:00:00', '2023-04-05 11:00:00', 'Retorno semestral', 'Concluído', 800.00, 24, 24),
('2023-04-06 16:00:00', '2023-04-06 17:00:00', 'Presente de Dia das Mães', 'Concluído', 600.00, 25, 25),
('2023-04-07 13:00:00', '2023-04-07 14:30:00', 'Cliente novo', 'Concluído', 300.00, 26, 26),
('2023-04-09 15:30:00', '2023-04-09 16:15:00', 'Casamento', 'Concluído', 220.00, 27, 27),
('2023-04-10 10:00:00', '2023-04-10 11:30:00', 'Pacote de 5 sessões', 'Concluído', 180.00, 28, 28),
('2023-04-11 17:00:00', '2023-04-11 18:15:00', 'Pele ressecada', 'Concluído', 250.00, 29, 29),
('2023-04-12 09:30:00', '2023-04-12 10:30:00', 'Retorno quinzenal', 'Cancelado', 200.00, 30, 30),
('2023-07-10 09:00:00', '2023-07-10 10:00:00', 'Cliente com pele sensível', 'Concluído', 150.00, 1, 4),
('2023-07-12 14:00:00', '2023-07-12 15:00:00', 'Retorno mensal', 'Concluído', 150.00, 2, 4),
('2023-07-15 10:30:00', '2023-07-15 11:30:00', 'Primeira sessão', 'Concluído', 150.00, 3, 5),
('2023-07-18 16:00:00', '2023-07-18 17:00:00', 'Presente de aniversário', 'Concluído', 150.00, 4, 4),
('2023-07-20 11:00:00', '2023-07-20 12:00:00', 'Preparação para evento', 'Concluído', 150.00, 5, 5);

INSERT INTO Agendamentos_servicos (valor, id_agendamento_fk, id_servico_fk) VALUES
(150.00, 1, 1), (120.00, 2, 2), (180.00, 3, 4), (500.00, 4, 5),(600.00, 5, 6), 
(160.00, 6, 7), (80.00, 7, 8), (100.00, 8, 9),(150.00, 9, 10), (150.00, 10, 1), 
(350.00, 11, 11), (280.00, 12, 12), (1200.00, 13, 13), (800.00, 14, 14),
(600.00, 15, 15), (300.00, 16, 16), (220.00, 17, 17), (180.00, 18, 18),
(250.00, 19, 19), (200.00, 20, 20), (350.00, 21, 11), (280.00, 22, 12),
(1200.00, 23, 13), (800.00, 24, 14), (600.00, 25, 15), (300.00, 26, 16),
(220.00, 27, 17), (180.00, 28, 18), (250.00, 29, 19), (200.00, 30, 20),
(150.00, 31, 1), (150.00, 32, 1), (150.00, 33, 1),(150.00, 34, 1), (150.00, 35, 1);

INSERT INTO Atendimentos (dataHoraInicial, dataHoraFinal, observacao, status, duracao, valorTotal, formaPagamento, id_agendamento_fk, id_funcionario_fk) VALUES
('2023-01-02 09:00:00', '2023-01-02 10:05:00', 'Cliente chegou 5 min atrasado', 'Finalizado', '01:05:00', 150.00, 'Cartão de Débito', 1, 4),
('2023-01-02 10:30:00', '2023-01-02 11:15:00', 'Cliente adorou o serviço', 'Finalizado', '00:45:00', 120.00, 'Dinheiro', 2, 5),
('2023-01-03 14:00:00', '2023-01-03 15:10:00', 'Aplicou creme especial', 'Finalizado', '01:10:00', 180.00, 'Cartão de Crédito', 3, 6),
('2023-01-04 11:00:00', '2023-01-04 11:50:00', 'Resultado excelente', 'Finalizado', '00:50:00', 500.00, 'PIX', 4, 7),
('2023-01-05 16:00:00', '2023-01-05 16:55:00', 'Presente bem recebido', 'Finalizado', '00:55:00', 600.00, 'Cartão de Débito', 5, 8),
('2023-01-06 13:00:00', '2023-01-06 13:55:00', 'Cliente marcou retorno', 'Finalizado', '00:55:00', 160.00, 'Dinheiro', 6, 9),
('2023-01-07 15:30:00', '2023-01-07 16:05:00', 'Sobrancelha perfeita', 'Finalizado', '00:35:00', 80.00, 'Cartão de Crédito', 7, 10),
('2023-01-09 10:00:00', '2023-01-09 11:25:00', 'Pacote iniciado', 'Finalizado', '01:25:00', 100.00, 'PIX', 8, 4),
('2023-01-10 17:00:00', '2023-01-10 18:10:00', 'Cabelos hidratados', 'Finalizado', '01:10:00', 150.00, 'Dinheiro', 9, 5),
('2023-01-11 09:30:00', NULL, 'Cliente cancelou', 'Cancelado', NULL, 0.00, NULL, 10, 6),
('2023-03-02 09:00:00', '2023-03-02 10:35:00', 'Cliente chegou atrasado', 'Finalizado', '01:35:00', 350.00, 'Cartão de Crédito', 11, 11),
('2023-03-02 11:00:00', '2023-03-02 12:05:00', 'Cliente satisfeito', 'Finalizado', '01:05:00', 280.00, 'PIX', 12, 12),
('2023-03-03 14:00:00', '2023-03-03 15:20:00', 'Usou produto especial', 'Finalizado', '01:20:00', 1200.00, 'Cartão de Débito', 13, 13),
('2023-03-04 10:00:00', '2023-03-04 11:05:00', 'Resultado excelente', 'Finalizado', '01:05:00', 800.00, 'Dinheiro', 14, 14),
('2023-03-05 16:00:00', '2023-03-05 17:10:00', 'Presente bem recebido', 'Finalizado', '01:10:00', 600.00, 'Cartão de Crédito', 15, 15),
('2023-03-06 13:00:00', '2023-03-06 14:40:00', 'Cliente marcou retorno', 'Finalizado', '01:40:00', 300.00, 'PIX', 16, 16),
('2023-03-07 15:30:00', '2023-03-07 16:20:00', 'Para evento especial', 'Finalizado', '00:50:00', 220.00, 'Dinheiro', 17, 17),
('2023-03-09 10:00:00', '2023-03-09 11:40:00', 'Pacote iniciado', 'Finalizado', '01:40:00', 180.00, 'Cartão de Débito', 18, 18),
('2023-03-10 17:00:00', '2023-03-10 18:20:00', 'Melhora significativa', 'Finalizado', '01:20:00', 250.00, 'Cartão de Crédito', 19, 19),
('2023-03-11 09:30:00', NULL, 'Cliente desistiu', 'Cancelado', NULL, 0.00, NULL, 20, 20),
('2023-04-02 09:00:00', '2023-04-02 10:40:00', 'Cliente fiel', 'Finalizado', '01:40:00', 350.00, 'PIX', 21, 21),
('2023-04-03 11:00:00', '2023-04-03 12:10:00', 'Primeira aplicação', 'Finalizado', '01:10:00', 280.00, 'Dinheiro', 22, 22),
('2023-04-04 14:00:00', '2023-04-04 15:25:00', 'Usou creme especial', 'Finalizado', '01:25:00', 1200.00, 'Cartão de Crédito', 23, 23),
('2023-04-05 10:00:00', '2023-04-05 11:15:00', 'Evolução positiva', 'Finalizado', '01:15:00', 800.00, 'Cartão de Débito', 24, 24),
('2023-04-06 16:00:00', '2023-04-06 17:15:00', 'Presente especial', 'Finalizado', '01:15:00', 600.00, 'PIX', 25, 25),
('2023-04-07 13:00:00', '2023-04-07 14:45:00', 'Novo cliente', 'Finalizado', '01:45:00', 300.00, 'Dinheiro', 26, 26),
('2023-04-09 15:30:00', '2023-04-09 16:25:00', 'Para evento', 'Finalizado', '00:55:00', 220.00, 'Cartão de Crédito', 27, 27),
('2023-04-10 10:00:00', '2023-04-10 11:45:00', 'Pacote em andamento', 'Finalizado', '01:45:00', 180.00, 'Cartão de Débito', 28, 28),
('2023-04-11 17:00:00', '2023-04-11 18:25:00', 'Melhora visível', 'Finalizado', '01:25:00', 250.00, 'PIX', 29, 29),
('2023-04-12 09:30:00', NULL, 'Cliente adiou', 'Cancelado', NULL, 0.00, NULL, 30, 30),
('2023-07-10 09:05:00', '2023-07-10 10:05:00', 'Usou produtos hipoalergênicos', 'Finalizado', '01:00:00', 150.00, 'Cartão de Débito', 31, 1),
('2023-07-12 14:00:00', '2023-07-12 15:05:00', 'Melhora na acne visível', 'Finalizado', '01:05:00', 150.00, 'PIX', 32, 1),
('2023-07-15 10:35:00', '2023-07-15 11:40:00', 'Muita oleosidade na pele T', 'Finalizado', '01:05:00', 150.00, 'Dinheiro', 33, 1),
('2023-07-18 16:00:00', '2023-07-18 17:00:00', 'Pele muito ressecada', 'Finalizado', '01:00:00', 150.00, 'Cartão de Crédito', 34, 1),
('2023-07-20 11:05:00', '2023-07-20 12:10:00', 'Extração de cravos necessária', 'Finalizado', '01:05:00', 150.00, 'PIX', 35, 1);

INSERT INTO Atendimentos_servicos (valor, id_atendimento_fk, id_servico_fk) VALUES
(150.00, 1, 1), (120.00, 2, 2), (180.00, 3, 4), (500.00, 4, 5),(600.00, 5, 6), 
(160.00, 6, 7), (80.00, 7, 8), (100.00, 8, 9),(150.00, 9, 10), (0.00, 10, 1),
(350.00, 11, 11), (280.00, 12, 12), (1200.00, 13, 13), (800.00, 14, 14),
(600.00, 15, 15), (300.00, 16, 16), (220.00, 17, 17), (180.00, 18, 18),
(250.00, 19, 19), (0.00, 20, 20), (350.00, 21, 11), (280.00, 22, 12),
(1200.00, 23, 13), (800.00, 24, 14), (600.00, 25, 15), (300.00, 26, 16),
(220.00, 27, 17), (180.00, 28, 18), (250.00, 29, 19), (0.00, 30, 20),
(150.00, 31, 1), (150.00, 32, 1), (150.00, 33, 1),(150.00, 34, 1), (150.00, 35, 1);

INSERT INTO Recebimentos (valor, tipoPagamento, parcela, dataHora, status, percentualDesconto, id_atendimento_fk, id_caixa_fk) VALUES
(150.00, 'Cartão de Débito', 1, '2023-01-02 10:10:00', 'Pago', 0.00, 1, 1),
(120.00, 'Dinheiro', 1, '2023-01-02 11:20:00', 'Pago', 0.00, 2, 1),
(180.00, 'Cartão de Crédito', 1, '2023-01-03 15:15:00', 'Pago', 0.00, 3, 2),
(500.00, 'PIX', 1, '2023-01-04 11:55:00', 'Pago', 0.00, 4, 3),
(600.00, 'Cartão de Débito', 1, '2023-01-05 17:00:00', 'Pago', 0.00, 5, 4),
(160.00, 'Dinheiro', 1, '2023-01-06 14:05:00', 'Pago', 0.00, 6, 5),
(80.00, 'Cartão de Crédito', 1, '2023-01-07 16:10:00', 'Pago', 0.00, 7, 6),
(100.00, 'PIX', 1, '2023-01-09 11:30:00', 'Pago', 0.00, 8, 7),
(150.00, 'Dinheiro', 1, '2023-01-10 18:15:00', 'Pago', 0.00, 9, 8),
(0.00, NULL, NULL, NULL, 'Cancelado', 0.00, 10, NULL),
(350.00, 'Cartão de Crédito', 1, '2023-03-02 10:40:00', 'Pago', 0.00, 11, 11),
(280.00, 'PIX', 1, '2023-03-02 12:10:00', 'Pago', 0.00, 12, 11),
(1200.00, 'Cartão de Débito', 1, '2023-03-03 15:25:00', 'Pago', 0.00, 13, 12),
(800.00, 'Dinheiro', 1, '2023-03-04 11:10:00', 'Pago', 0.00, 14, 13),
(600.00, 'Cartão de Crédito', 1, '2023-03-05 17:15:00', 'Pago', 0.00, 15, 14),
(300.00, 'PIX', 1, '2023-03-06 14:45:00', 'Pago', 0.00, 16, 15),
(220.00, 'Dinheiro', 1, '2023-03-07 16:25:00', 'Pago', 0.00, 17, 16),
(180.00, 'Cartão de Débito', 1, '2023-03-09 11:45:00', 'Pago', 0.00, 18, 17),
(250.00, 'Cartão de Crédito', 1, '2023-03-10 18:25:00', 'Pago', 0.00, 19, 18),
(0.00, NULL, NULL, NULL, 'Cancelado', 0.00, 20, NULL),
(350.00, 'PIX', 1, '2023-04-02 10:45:00', 'Pago', 0.00, 21, 21),
(280.00, 'Dinheiro', 1, '2023-04-03 12:15:00', 'Pago', 0.00, 22, 21),
(1200.00, 'Cartão de Crédito', 1, '2023-04-04 15:30:00', 'Pago', 0.00, 23, 22),
(800.00, 'Cartão de Débito', 1, '2023-04-05 11:20:00', 'Pago', 0.00, 24, 23),
(600.00, 'PIX', 1, '2023-04-06 17:20:00', 'Pago', 0.00, 25, 24),
(300.00, 'Dinheiro', 1, '2023-04-07 14:50:00', 'Pago', 0.00, 26, 25),
(220.00, 'Cartão de Crédito', 1, '2023-04-09 16:30:00', 'Pago', 0.00, 27, 26),
(180.00, 'Cartão de Débito', 1, '2023-04-10 11:50:00', 'Pago', 0.00, 28, 27),
(250.00, 'PIX', 1, '2023-04-11 18:30:00', 'Pago', 0.00, 29, 28),
(0.00, NULL, NULL, NULL, 'Cancelado', 0.00, 30, NULL),
(150.00, 'Cartão de Débito', 1, '2023-07-10 10:10:00', 'Pago', 0.00, 31, 1),
(150.00, 'PIX', 1, '2023-07-12 15:10:00', 'Pago', 0.00, 32, 1),
(150.00, 'Dinheiro', 1, '2023-07-15 11:45:00', 'Pago', 0.00, 33, 2),
(150.00, 'Cartão de Crédito', 1, '2023-07-18 17:05:00', 'Pago', 0.00, 34, 2),
(150.00, 'PIX', 1, '2023-07-20 12:15:00', 'Pago', 0.00, 35, 3);

INSERT INTO Comissao (percentual, valorTotal, status, observacao, dataHora, id_atendimento_fk, id_funcionario_fk) VALUES
(10.00, 15.00, 'Pago', 'Comissão normal', '2023-01-02 18:30:00', 1, 4),
(15.00, 18.00, 'Pago', 'Comissão normal', '2023-01-02 18:30:00', 2, 5),
(20.00, 36.00, 'Pago', 'Comissão normal', '2023-01-03 18:30:00', 3, 6),
(25.00, 125.00, 'Pago', 'Comissão especial', '2023-01-04 18:30:00', 4, 7),
(30.00, 180.00, 'Pago', 'Comissão especial', '2023-01-05 18:30:00', 5, 8),
(15.00, 24.00, 'Pago', 'Comissão normal', '2023-01-06 18:30:00', 6, 9),
(10.00, 8.00, 'Pago', 'Comissão normal', '2023-01-07 18:30:00', 7, 10),
(20.00, 20.00, 'Pago', 'Comissão normal', '2023-01-09 18:30:00', 8, 4),
(15.00, 22.50, 'Pago', 'Comissão normal', '2023-01-10 18:30:00', 9, 5),
(0.00, 0.00, 'Cancelado', 'Atendimento cancelado', NULL, 10, 6),
(15.00, 52.50, 'Pago', 'Comissão normal', '2023-03-02 18:30:00', 11, 11),
(20.00, 56.00, 'Pago', 'Comissão normal', '2023-03-02 18:30:00', 12, 12),
(25.00, 300.00, 'Pago', 'Comissão especial', '2023-03-03 18:30:00', 13, 13),
(15.00, 120.00, 'Pago', 'Comissão normal', '2023-03-04 18:30:00', 14, 14),
(20.00, 120.00, 'Pago', 'Comissão normal', '2023-03-05 18:30:00', 15, 15),
(15.00, 45.00, 'Pago', 'Comissão normal', '2023-03-06 18:30:00', 16, 16),
(10.00, 22.00, 'Pago', 'Comissão normal', '2023-03-07 18:30:00', 17, 17),
(20.00, 36.00, 'Pago', 'Comissão normal', '2023-03-09 18:30:00', 18, 18),
(15.00, 37.50, 'Pago', 'Comissão normal', '2023-03-10 18:30:00', 19, 19),
(0.00, 0.00, 'Cancelado', 'Atendimento cancelado', NULL, 20, 20),
(15.00, 52.50, 'Pago', 'Comissão normal', '2023-04-02 18:30:00', 21, 21),
(20.00, 56.00, 'Pago', 'Comissão normal', '2023-04-03 18:30:00', 22, 22),
(25.00, 300.00, 'Pago', 'Comissão especial', '2023-04-04 18:30:00', 23, 23),
(15.00, 120.00, 'Pago', 'Comissão normal', '2023-04-05 18:30:00', 24, 24),
(20.00, 120.00, 'Pago', 'Comissão normal', '2023-04-06 18:30:00', 25, 25),
(15.00, 45.00, 'Pago', 'Comissão normal', '2023-04-07 18:30:00', 26, 26),
(10.00, 22.00, 'Pago', 'Comissão normal', '2023-04-09 18:30:00', 27, 27),
(20.00, 36.00, 'Pago', 'Comissão normal', '2023-04-10 18:30:00', 28, 28),
(15.00, 37.50, 'Pago', 'Comissão normal', '2023-04-11 18:30:00', 29, 29),
(0.00, 0.00, 'Cancelado', 'Atendimento cancelado', NULL, 30, 30),
(15.00, 22.50, 'Pago', 'Comissão serviço limpeza de pele', '2023-07-10 18:00:00', 31, 1),
(15.00, 22.50, 'Pago', 'Comissão retorno mensal', '2023-07-12 18:00:00', 32, 1),
(20.00, 30.00, 'Pago', 'Comissão primeira sessão (bônus)', '2023-07-15 18:00:00', 33, 1),
(15.00, 22.50, 'Pago', 'Comissão presente', '2023-07-18 18:00:00', 34, 1),
(15.00, 22.50, 'Pago', 'Comissão extração de cravos', '2023-07-20 18:00:00', 35, 1);

INSERT INTO Pagamentos (valor, tipoPagamento, parcela, dataHora, status, id_despesa_fk, id_caixa_fk, id_comissao_fk) VALUES
(1200.00, 'Cartão de Crédito', 1, '2023-01-05 10:05:00', 'Pago', 1, 4, NULL),
(800.00, 'Boleto', 1, '2023-01-10 15:00:00', 'Pago', 2, 7, NULL),
(150.00, 'Débito Automático', 1, '2023-01-15 09:05:00', 'Pago', 3, NULL, NULL),
(300.00, 'Dinheiro', 1, '2023-01-20 11:20:00', 'Pago', 4, NULL, NULL),
(200.00, 'Débito Automático', 1, '2023-01-25 08:50:00', 'Pago', 5, NULL, NULL),
(15.00, 'Dinheiro', 1, '2023-01-02 18:35:00', 'Pago', NULL, 1, 1),
(18.00, 'Dinheiro', 1, '2023-01-02 18:35:00', 'Pago', NULL, 1, 2),
(36.00, 'Dinheiro', 1, '2023-01-03 18:35:00', 'Pago', NULL, 2, 3),
(125.00, 'Dinheiro', 1, '2023-01-04 18:35:00', 'Pago', NULL, 3, 4),
(180.00, 'Dinheiro', 1, '2023-01-05 18:35:00', 'Pago', NULL, 4, 5),
(2500.00, 'Cartão de Crédito', 1, '2023-03-05 10:05:00', 'Pago', 11, 14, NULL),
(1200.00, 'Boleto', 1, '2023-03-10 15:00:00', 'Pago', 12, 17, NULL),
(3500.00, 'Débito Automático', 1, '2023-03-15 09:05:00', 'Pago', 13, NULL, NULL),
(800.00, 'Dinheiro', 1, '2023-03-20 11:20:00', 'Pago', 14, NULL, NULL),
(450.00, 'Débito Automático', 1, '2023-03-25 08:50:00', 'Pago', 15, NULL, NULL),
(52.50, 'Dinheiro', 1, '2023-03-02 18:35:00', 'Pago', NULL, 11, 11),
(56.00, 'Dinheiro', 1, '2023-03-02 18:35:00', 'Pago', NULL, 11, 12),
(300.00, 'Dinheiro', 1, '2023-03-03 18:35:00', 'Pago', NULL, 12, 13),
(120.00, 'Dinheiro', 1, '2023-03-04 18:35:00', 'Pago', NULL, 13, 14),
(120.00, 'Dinheiro', 1, '2023-03-05 18:35:00', 'Pago', NULL, 14, 15),
(2800.00, 'Cartão de Crédito', 1, '2023-05-05 10:05:00', 'Pago', 21, 24, NULL),
(850.00, 'Boleto', 1, '2023-05-10 15:00:00', 'Pago', 22, 27, NULL),
(180.00, 'Débito Automático', 1, '2023-05-15 09:05:00', 'Pago', 23, NULL, NULL),
(400.00, 'Dinheiro', 1, '2023-05-20 11:20:00', 'Pago', 24, NULL, NULL),
(220.00, 'Débito Automático', 1, '2023-05-25 08:50:00', 'Pago', 25, NULL, NULL),
(52.50, 'Dinheiro', 1, '2023-04-02 18:35:00', 'Pago', NULL, 21, 21),
(56.00, 'Dinheiro', 1, '2023-04-03 18:35:00', 'Pago', NULL, 21, 22),
(300.00, 'Dinheiro', 1, '2023-04-04 18:35:00', 'Pago', NULL, 22, 23),
(120.00, 'Dinheiro', 1, '2023-04-05 18:35:00', 'Pago', NULL, 23, 24),
(120.00, 'Dinheiro', 1, '2023-04-06 18:35:00', 'Pago', NULL, 24, 25),
(22.50, 'Dinheiro', 1, '2023-07-10 18:05:00', 'Pago', NULL, 1, 31),
(22.50, 'Dinheiro', 1, '2023-07-12 18:05:00', 'Pago', NULL, 1, 32),
(30.00, 'Dinheiro', 1, '2023-07-15 18:05:00', 'Pago', NULL, 2, 33),
(22.50, 'Dinheiro', 1, '2023-07-18 18:05:00', 'Pago', NULL, 2, 34),
(22.50, 'Dinheiro', 1, '2023-07-20 18:05:00', 'Pago', NULL, 3, 35);